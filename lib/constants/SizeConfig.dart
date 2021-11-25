import 'package:flutter/material.dart';

class SizeConfig {
  static double? screenwidth;
  static double? screenheight;
  void init(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    screenheight! * 0.024;
    screenwidth! * 0.024;
  }
}
