import io show *
import encoding.base64 show *

F64 ::= 8

class ListF64RWB :

  buffer_/Buffer := ?

  constructor :
    buffer_ = Buffer

  put list/List -> none :
    capacity/int := F64*list.size
    buffer_ = Buffer.with-capacity capacity
    buffer_.grow-by capacity
    for i := 0; i < list.size; i++ :
      buffer_.little-endian.put-float64 --at=i*F64 list[i]
    //print "put.buffer_.size->$buffer_.size"

  get -> List :
    result/List := []
    size/int := buffer_.size / F64
    for i := 0; i < size; i++ :
      value := buffer_.little-endian.float64 --at=i*F64
      result.add value
    return result

  // restoreList b_size/int -> List :
  //   result/List := []
  //   size/int := buffer_.size / F64

  //   size_x := min b_size size

  //   for i := 0; i < size_x; i++ :
  //     value := buffer_.little-endian.float64 --at=i*F64
  //     result.add value
  //   return result

  getBase64Str -> string :
    byteArray/ByteArray := buffer_.backing-array
    //print "getBase64Str.byteArray.size->$byteArray.size"
    base64str/string := encode byteArray
    return base64str

  putBase64Str base64str/string -> none :
    buffer_.clear
    byteArray/ByteArray := decode base64str
    //print "putBase64Str.byteArray.size->$byteArray.size"
    for i := 0; i < byteArray.size; i++ :
      byte := byteArray[i]
      buffer_.write-byte byte
