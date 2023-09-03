import 'package:flutter/material.dart';

Widget normalButton(String title, Function callBack, {Color? color, double? width, double? height}) {
  return GestureDetector(
    onTap: () {
      callBack();
    },
    child: Container(
      height: height ?? 50,
      width: width ?? double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color ?? Colors.blue,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.blue,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
