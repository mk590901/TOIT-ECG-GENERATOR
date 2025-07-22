import encoding.json
import encoding.base64
import .list_rwb

class DataPacket :
  
  sensor_id_/string := ""
  sensor_name_/string := ""
  series_length_/int := 0
  raw_data_/List := []

  rwbHub := ListF64RWB

  constructor .sensor_id_ .sensor_name_ .series_length_ .raw_data_ :

  constructor.empty :

  encode -> string :
    
    rwbHub.put raw_data_
    raw_data_base64 := rwbHub.getBase64Str
    packet_metadata := { "sensor_id": sensor_id_, "sensor_name": sensor_name_, "series_length": series_length_, "raw_data": raw_data_base64 }
    jsonObject := json.encode packet_metadata
    return jsonObject.to_string 

  decode json_string/string -> DataPacket : 

    metadata := json.parse json_string
    sensor_id := metadata["sensor_id"]
    sensor_name := metadata["sensor_name"]
    series_length := metadata["series_length"]
    rwbHub.putBase64Str metadata["raw_data"]
    raw_data := rwbHub.restoreList series_length
    return DataPacket sensor_id sensor_name series_length raw_data

  