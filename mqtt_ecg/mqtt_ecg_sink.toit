import gpio
import uuid show *
import pixel_strip show PixelStrip
import mqtt
import monitor
import encoding.json
import .periodic_timer show *
import .utils show *
import .data_packet show *
import .ecg_wave show *

CLIENT-ID ::= "toit-subscribe"

HOST ::= "broker.hivemq.com"
TOPIC ::= "cmd_v2/topic"
OUT_TOPIC ::= "hsm_v2/topic"

latch ::= monitor.Latch //  Monitor for sync

pin := gpio.Pin 48
strip := PixelStrip.uart 1 --pin=pin

sensorId/string := ?

set_and_reset_color number/int red/int green/int blue/int :
  r := ByteArray 1; g := ByteArray 1; b := ByteArray 1
  number.repeat :
    r[0] = red; g[0] = green; b[0] = blue
    strip.output r g b
    sleep --ms=100
    r[0] = 0; g[0] = 0; b[0] = 0
    strip.output r g b
    sleep --ms=100

set_color red/int green/int blue/int :
  r := ByteArray 1; g := ByteArray 1; b := ByteArray 1
  r[0] = red; g[0] = green; b[0] = blue
  strip.output r g b
  sleep --ms=100

blink number/int red/int green/int blue/int :
  task::
    set_and_reset_color number red green blue

color red/int green/int blue/int :
  task::
    set_color red green blue

publish client/mqtt.Client message :
  task::
    client.publish OUT_TOPIC message

startEcg timer/PeriodicTimer cb/Lambda -> none :
  print "******* startEcg *******"
  sensorId = "sen_" + Uuid.random.to_string[..4]
  timer.start cb

finalEcg timer/PeriodicTimer -> none :
  print "******* finalEcg *******"
  timer.final

fun client/mqtt.Client parameter/string -> none :
  list/List := generate_ecg //sine_wave 128
  packet := DataPacket sensorId "esp32_s3" simple_rate list
  encoded/string := packet.encode
  //print "($time)"
  publish client encoded
  blink 1 0 255 0

main:

  timer := PeriodicTimer

  set_color 255 255 0 //  YELLOW -> indicate app start

//  Create MQTT-client  

  client := mqtt.Client --host=HOST
  
//  Connect to broker

  client.start --client-id=CLIENT-ID
      --on-error=:: print "Client error: $it"

  print "Connected to MQTT broker $HOST"

  set_color 0 255 0 //  GREEN -> indicate app connected

//  Subscribe to topic

  command/string := ""
  decoded/string := ""
  hasCmd/bool := false

  client.subscribe TOPIC:: | topic/string payload/ByteArray |
    
    decoded = payload.to_string
    
    print "Received message on '$topic': $decoded"

    map := json.parse decoded

    hasCmd = map.contains "cmd"

    print ("hasCmd->$hasCmd");
      
    if hasCmd :
      command = map["cmd"]
      if (command == "stop") :
        timer.final
        latch.set true
        print ("Stopping app...")
      else :
        print ("command->[$command]")
        if (command == "startEcg") :
          startEcg timer (::fun client "> timer tick -- ")
        if (command == "finalEcg") :
          finalEcg timer


// Wait ending signal
  latch.get
  publish client decoded
  sleep --ms=500
// Disconnect
  client.close
  print "Disconnected from MQTT broker $HOST"
  blink 5 0 204 0


