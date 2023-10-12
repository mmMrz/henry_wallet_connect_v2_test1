// Dart imports:
import 'dart:convert' show utf8;
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/foundation.dart';

class HexUtils {
  static String uint8ToHex(Uint8List byteArr) {
    if (byteArr == null || byteArr.length == 0) {
      return "";
    }
    Uint8List result = Uint8List(byteArr.length << 1);
    var hexTable = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ]; //16进制字符表
    for (var i = 0; i < byteArr.length; i++) {
      var bit = byteArr[i]; //取传入的byteArr的每一位
      var index = bit >> 4 & 15; //右移4位,取剩下四位
      var i2 = i << 1; //byteArr的每一位对应结果的两位,所以对于结果的操作位数要乘2
      result[i2] = hexTable[index].codeUnitAt(0); //左边的值取字符表,转为Unicode放进resut数组
      index = bit & 15; //取右边四位
      result[i2 + 1] =
          hexTable[index].codeUnitAt(0); //右边的值取字符表,转为Unicode放进resut数组
    }
    return String.fromCharCodes(result); //Unicode转回为对应字符,生成字符串返回
  }

  static String remove0X(String content) {
    if (content.startsWith("0x") || content.startsWith("0X")) {
      content = content.substring(2);
    }
    return content;
  }

  static String hexToString(String hex0x) {
    String hex = hex0x;
    if (hex.startsWith("0x") || hex.startsWith("0X")) {
      hex = HexUtils.remove0X(hex);
    } else if (hex.indexOf(" ") != -1 || hex.indexOf(":") != -1) {
      return hex;
    }

    String result = "";
    for (var i = 0; i < hex.length; i += 2) {
      String codeStr = hex.substring(i, i + 2);
      int codeInt = int.parse(codeStr, radix: 16);
      final char = String.fromCharCode(codeInt);
      final ut8Char = utf8.encode(char).join();
      if (ut8Char != '0') {
        // This line to ensure character with utf8 charcode equal = 0 that is strange character will be filtered
        result += char;
      }
    }
    return result;
  }

  //16进制字符串转List<int>
  static List<int> hexToListInt(String hex0x) {
    String hex = HexUtils.remove0X(hex0x);
    List<int> result = [];
    for (var i = 0; i < hex.length; i += 2) {
      String codeStr = hex.substring(i, i + 2);
      int codeInt = int.parse(codeStr, radix: 16);
      result.add(codeInt);
    }
    return result;
  }

  static Uint8List hexToUint8List(String hex0x) {
    String hex = HexUtils.remove0X(hex0x);
    Uint8List result = Uint8List(hex.length >> 1);
    for (var i = 0; i < hex.length; i += 2) {
      String codeStr = hex.substring(i, i + 2);
      int codeInt = int.parse(codeStr, radix: 16);
      result[i >> 1] = codeInt;
    }
    return result;
  }

  static Uint8List stringToBytes(String str) {
    return Uint8List.fromList(utf8.encode(str));
  }
}
