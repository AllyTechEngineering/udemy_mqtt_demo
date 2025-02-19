# udemy_led_demo

LED Demo Using BLoC

## Getting Started

## Install Mosquitto MqTT Broker
Update and upgrade your Linux
```
sudo apt update
sudo apt upgrade
```
- Install Mosquitto on the Pi

```
sudo apt install mosquitto mosquitto-clients -y
```
- Enable Mosquitto
```
sudo systemctl enable mosquitto
```
- Start Mosquitto
```
sudo systemctl start mosquitto
```
- Verify that Mosquito is running
```
sudo systemctl status mosquitto
```
- The response will include: 
``
Active: active (running)
``
- Ensure Mosquitto starts on boot:
- Reboot the Pi
```
sudo reboot
```
- After the reboot, verify Mosquitto is running:
```
sudo systemctl status mosquitto
```
- The response will include: 
``
Active: active (running)
``

- Check open ports - run this command:
```
sudo netstat -tulnp | grep mosquitto

```
The response should include:
``
tcp        0      0 0.0.0.0:1883            0.0.0.0:*               LISTEN      884/mosquitto  
``
- Find your Pi's local  IP adress
```
hostname -I
```
- Create a custom Mosquitto config file
```
sudo nano /etc/mosquitto/conf.d/local.conf
```
- Add these lines:
```
listener 1883
allow_anonymous true
```
- You will need to restart Mosquitto:
```
sudo systemctl restart mosquitto
```
- Verify Mosquitto is listening on all interfaces:
```
sudo netstat -tulnp | grep mosquitto
```
The response should include:
``
tcp        0      0 0.0.0.0:1883            0.0.0.0:*               LISTEN      884/mosquitto  
``

## Local Pi test using two terminal windows:
- Terminal 1 (start an MQTT subscriber)
```
mosquitto_sub -h localhost -t "test/topic"
```
- Terminal 2 (publish a test message)
```
mosquitto_pub -h localhost -t "test/topic" -m "Hello from Pi MQTT!"
```
- If "Hello from Pi MQTT!" appears in Terminal 1, Mosquitto is working locally.

## Test MQTT from Another Device
- On the other device:
```
mosquitto_sub -h 192.168.1.202 -t "test/topic"
```
- On the Raspberry Pi:
```
mosquitto_pub -h localhost -t "test/topic" -m "Hello from Raspberry Pi!"
```
- If the message appears on the other device, Mosquitto is fully network-accessible! 