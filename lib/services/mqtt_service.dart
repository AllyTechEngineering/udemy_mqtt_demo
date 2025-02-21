import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:udemy_mqtt_demo/bloc/data_repository/data_repository.dart';
import '../models/device_state_model.dart';

class MqttService {
  final String _broker = "192.168.1.202"; // Raspberry Pi IP
  final int _port = 1883;
  final String _username = "allytech";
  final String _password = "Happy2025?";
  final String _clientId = "flutter_client";
  final String _topic = "device/state";

  late MqttServerClient _client;
  final DataRepository _dataRepository;

  MqttService(this._dataRepository) {
    _initializeClient();
  }

  void _initializeClient() {
    _client = MqttServerClient(_broker, _clientId);
    _client.port = _port;
    _client.logging(on: false);
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
  }

  /// Connect to MQTT Broker
  Future<void> connect() async {
    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .authenticateAs(_username, _password)
        .startClean() // Ensures no old session is retained
        .withWillQos(MqttQos.atMostOnce);

    try {
      debugPrint('Connecting to MQTT broker...');
      await _client.connect();

      if (_client.connectionStatus!.state == MqttConnectionState.connected) {
        debugPrint('Connected to MQTT broker at $_broker');
        _subscribeToTopic();
      } else {
        debugPrint('Failed to connect: ${_client.connectionStatus}');
      }
    } catch (e) {
      debugPrint('MQTT Connection error: $e');
      _reconnect();
    }
  }

  /// Subscribe to the topic
  void _subscribeToTopic() {
    _client.subscribe(_topic, MqttQos.atMostOnce);
    _client.updates?.listen(_onMessageReceived);
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>> messages) {
    final MqttPublishMessage message =
        messages[0].payload as MqttPublishMessage;
    final String payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    debugPrint("Received MQTT message: $payload");

    try {
      final Map<String, dynamic> jsonData = jsonDecode(payload);
      final newState = DeviceStateModel.fromJson(jsonData);

      // Prevent infinite loop: Only update state if it changed
      if (newState != _dataRepository.deviceState) {
        _dataRepository.updateDeviceState(newState,
            publish: false); // Do NOT publish again
        debugPrint("Updated device state from MQTT.");
      } else {
        debugPrint("Received duplicate state, ignoring update.");
      }
    } catch (e) {
      debugPrint("Error parsing MQTT data: $e");
    }
  }

  /// Publish DeviceStateModel to MQTT (ensures no duplicate messages)
  void publishDeviceState(DeviceStateModel state) {
    final String jsonState = jsonEncode(state.toJson());
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(jsonState);

    _client.publishMessage(_topic, MqttQos.atLeastOnce, builder.payload!);
    // debugPrint("Published MQTT data: $jsonState");
  }

  void _onConnected() {
    debugPrint('MQTT Connected.');
  }

  void _onDisconnected() {
    debugPrint('MQTT Disconnected. Attempting reconnect in 5 seconds...');
    _reconnect();
  }

  void _onSubscribed(String topic) {
    debugPrint('Subscribed to topic: $topic');
  }

  /// Handles automatic reconnection
  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), connect);
  }

  /// Clears retained messages (Run this once manually if needed)
  void clearRetainedMessages() {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    _client.publishMessage(_topic, MqttQos.atMostOnce, builder.payload!);
    debugPrint("Cleared retained MQTT messages.");
  }
}
