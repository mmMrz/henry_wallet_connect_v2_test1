// Dart imports:
import 'dart:math';

// Package imports:
import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

class NumberUtils {
  static Decimal addPrecision(String numStr, int precision) {
    if (numStr == null || numStr == "" || numStr == "0")
      return Decimal.fromInt(0);
    Rational rational =
        Decimal.parse(numStr) / Decimal.fromInt(10).pow(precision).toDecimal();
    Decimal result = rational.toDecimal();
    return result;
  }

  static BigInt removePrecision(String numStr, int precision) {
    BigInt result = BigInt.parse(
        (Decimal.parse(numStr) * Decimal.fromInt(10).pow(precision).toDecimal())
            .toString());
    return result;
  }

  static String doubleToString(double d, {int? presesion}) {
    String str = d.toString();
    if (presesion != null) {
      if ((str.length - str.lastIndexOf(".") - 1) > presesion) {
        str = str.substring(0, str.lastIndexOf(".") + presesion + 1).toString();
      }
    }
    return str;
  }

  /////test method
  static double weiToEth(BigInt amount, int decimal) {
    if (decimal == null) {
      double db = amount / BigInt.from(10).pow(18);
      return double.parse(db.toStringAsFixed(2));
    } else {
      double db = amount / BigInt.from(10).pow(decimal);
      return double.parse(db.toStringAsFixed(2));
    }
  }

  static double weiToEthUnTrimmed(BigInt amount, int decimal) {
    if (decimal == null) {
      double db = amount / BigInt.from(10).pow(18);
      return double.parse(db.toStringAsFixed(6));
    } else {
      double db = amount / BigInt.from(10).pow(decimal);
      return double.parse(db.toStringAsFixed(6));
    }
  }

  static String weiToGwei(BigInt amount) {
    var db = amount / BigInt.from(10).pow(9);
    return db.toStringAsPrecision(2);
  }

  static BigInt ethToWei(String amount, int decimal) {
    double db = double.parse(amount) * pow(10, 4);
    int it = db.toInt();
    BigInt bi = BigInt.from(it) *
        BigInt.from(10).pow(decimal == null ? 14 : decimal - 4);
    return bi;
  }
}
