# Toit ECG Generator

The application is a controlled (via __MQTT layer__) generator of an artificial ECG signal on on the __ESP32-S3-WROOM__ board.

## Introduction

The application provide a connection to the __MQTT broker__ and receive commands to start and end the process of generating an __ECG__ signal.

When a start command is received, a timer is started that generates an artificial ECG signal once per second and sends it as a list of double signal values packed into a binary vector. Next the data packet is generated in the application format https://github.com/mk590901/ECG-MQTT-SERVICE. The packet is sent to a pre-defined topic, to which the application is subscribed, providing playback of the __ECG__ signal.

## ECG generator

The application uses a very simple __ECG__ generator that forms it from basic waveform with __P__, __QRS__ and __T__ waves using simplest mathematical functions. The code of generator is in the file __ecg_wave.toit__. Please note the comments.


## Visual effects

Sending a command is accompanied by flashing

## Application end

## Monitoring

## Movie I
## Movie II
## Movie III
