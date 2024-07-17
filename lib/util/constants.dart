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


double getAdjustedHeight(double value, BuildContext context) {
    if (MediaQuery.of(context).size.aspectRatio > 1.77777777778) {
      return value;
    } else {
      return value *
          ((MediaQuery.of(context).size.aspectRatio) / (1.77777777778));
    }
  }

  double getAdjustedWidth(double value, BuildContext context) {
    if (MediaQuery.of(context).size.aspectRatio < 1.77777777778) {
      return value;
    } else {
      return value *
          ((1.77777777778) / (MediaQuery.of(context).size.aspectRatio));
    }
  }
