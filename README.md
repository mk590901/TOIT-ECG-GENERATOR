# Toit ECG Generator

The application is a controlled (via __MQTT layer__) generator of an artificial __ECG__ signal on on the __ESP32-S3-WROOM__ board.

## Introduction

The application provide a connection to the __MQTT broker__ and receive commands to start and end the process of generating an __ECG__ signal.

When a start command is received, a timer is started that generates an artificial ECG signal once per second and sends it as a list of double signal values packed into a binary vector. Next the data packet is generated in the application format https://github.com/mk590901/ECG-MQTT-SERVICE. The packet is sent to a pre-defined topic, to which the application is subscribed, providing playback of the __ECG__ signal.

## ECG generator

The application uses a very simple __ECG__ generator that forms it from basic waveform with __P__, __QRS__ and __T__ waves using simplest mathematical functions. The code of generator is in the file __ecg_wave.toit__. Please note the comments.

## Brief description of the application

1) When the application starts, an mqtt client is created, a connection to the broker is started, and a subscription to the topic is performed. This step is accompanied by a small visual effect: upon successful connection and subscription, the LED turns green.
   
2) Control commands are transmitted by subscription in the form of json strings. There are only three of them:
   * ECG start: _{"cmd":"startEcg"}_
   * ECG final: _{"cmd":"finalEcg"}_
   * application end: _{"cmd":"stop"}_
     
3) App time diagram

 <img width="2406" height="1425" alt="time diagram" src="https://github.com/user-attachments/assets/bb540c91-caa0-4bdd-bd15-77daf87c3aed" />

## Data Packing

It's worth paying attention to the method of packing the list of __ECG__ signal values. Pay attention to the __ListF64RWB__ class (_file list_rwb.toit_), or more precisely to the __put__ method, packing the list of real numbers into a __ByteArray__ in a format that corresponds to the __double__ of __Dart data format__. Then the __ByteArray__ is translated into a __Base64__ string, encapsulated in a __DataPacket__ structure (_file data_packet.toit_) and sent to the __mqtt broker__.

## Visual effects

Sending a data is accompanied by flashing

## Application management

> Installing packages:

* __mqtt__
```
micrcx@micrcx-desktop:~/toit/mqtt$ jag pkg install github.com/toitware/mqtt@v2
Info: Package 'github.com/toitware/mqtt@2.13.1' installed with name 'mqtt'
```
* __pixel_strip__
```
micrcx@micrcx-desktop:~/toit/mqtt$ jag pkg install github.com/toitware/toit-pixel-strip@v0.3
Info: Package 'github.com/toitware/toit-pixel-strip@0.3.0' installed with name 'pixel_strip'
```

> Loading the application:

```
micrcx@micrcx-desktop:~/toit/mqtt$ jag run mqtt_ecg_sink.toit
Running 'mqtt_ecg_sink.toit' on 'polished-bill' ...
Success: Sent 99KB code to 'polished-bill' in 2.79s
```

## Movie I

Controlling the __ESP32-S3__ oscillator by special __Flutter__ app

https://github.com/user-attachments/assets/3f1a2741-b914-4f50-a872-b069a9f013ac

## Movie II

__ECG Service App__ renders __ESP32-S3__ generator signals parallelly together with signals other __ECG__ sinks.

https://github.com/user-attachments/assets/a4b02263-b826-4602-b296-beff575b301c

## Movie III

The process of loading the application onto the chip, establish connection with __MQTT broker__, sending data and closing the application is reflected on video.

https://github.com/user-attachments/assets/93bc1801-4c66-4711-a0ad-8b25a19dae77

