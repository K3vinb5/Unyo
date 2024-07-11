import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? accessToken;
String? refreshToken;
String? accessCode;
bool receivedValid = false;
late SharedPreferences prefs; 
Color veryLightBorderColor = Colors.white;
Color lightBorderColor = Colors.grey;
Color darkBorderColor = Colors.black;
