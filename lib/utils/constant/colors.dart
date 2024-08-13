import 'package:flutter/material.dart';

class StateColor {
  final Color error = const Color(0xFFFF0000);
  final Color warning = const Color(0xFFEBD514);
  final Color success = const Color(0xFF24DA69);
}

class BackgroundColor {
  final Color darkpurple = const Color(0xff1D0C2B);
  final Color grey = const Color(0xffD9D9D9);
  final Color purple = const Color(0xff472C6C);
}

class ChartColor {
  final Color purple = const Color(0xff472C6C);
  final Color purpleWithOpacity = const Color.fromARGB(255, 111, 92, 135);
  final Color darkpurple = const Color(0xff1D0C2B);
}

class ButtonColor {
  final Color purple = const Color(0xff472C6C);
  final Color purpleWithOpacity = const Color(0xff5D467C);
  final Color darkpurple = const Color(0xff1D0C2B);
}

class IconColor {
  final Color darkpurple = const Color(0xff1D0C2B);
  final Color purple = const Color(0xff472C6C);
}

class TextColor {
  final Color lightpurple = const Color(0xffA8B3CE);
  final Color purple = const Color(0xff472C6C);
  final Color darkpurple = const Color(0xff1D0C2B);
  final Color grey = const Color(0xff788197);
  final Color green = const Color(0xff12C64B);
}

class FrameColor {
  final Color error = const Color(0xFFFF0000);
  final Color warning = const Color(0xFFEBD514);
  final Color success = const Color(0xFF24DA69);
  final Color white = Colors.white;
}

abstract class DertColor {
  DertColor._();
  static StateColor state = StateColor();
  static BackgroundColor background = BackgroundColor();
  static ChartColor chart = ChartColor();
  static ButtonColor button = ButtonColor();
  static IconColor icon = IconColor();
  static FrameColor frame = FrameColor();
  static TextColor text = TextColor();
}
