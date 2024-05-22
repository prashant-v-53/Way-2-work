import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/variable_keys.dart';

class NetworkClass {
  static unAuthenticatedUser(context, response) {
    var decoded = jsonDecode(response.body);
    toast(decoded['message']);
    Navigator.pushNamedAndRemoveUntil(
        context, RouteKeys.LOGIN, (route) => false);
  }

  static internetNotConnection(response) {
    var decoded = jsonDecode(response.body);
    toast(decoded['message']);
  }
}
