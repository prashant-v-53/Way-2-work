import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:way_to_work/elements/app_loader.dart';
import 'package:global_configuration/global_configuration.dart';

bool changeLang = false;

class Helper {
  BuildContext context;
  DateTime currentBackPressTime;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  static bool isEmail(String em) {
    print(em.length);
    print(em);
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isPassword(String em) {
    return em.length > 6;
  }

  static bool isPhoneNumber(String em) {
    String p = r'^[0-9]';
    RegExp regExp = new RegExp(p);
    return (regExp.hasMatch(em) && em.length >= 8);
  }

  static String convertDate(String date) {
    String convertedDate = '';
    try {
      DateTime dateTime = DateTime.parse(date.toString());
      var data = DateFormat('dd.MM.yyyy').format(dateTime);
      convertedDate = data.toString();
    } catch (e) {
      convertedDate = '';
    }
    return convertedDate;
  }

  static showCurrentPage(currentValue, list) {
    if (list.isEmpty)
      return '0/0';
    else
      return '${list.indexOf(currentValue) + 1} / ${list.length}';
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: AppLoader(),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader?.remove();
      } catch (e) {}
    });
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(GlobalConfiguration().getValue('base_url')).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(GlobalConfiguration().getValue('base_url')).scheme,
        host: Uri.parse(GlobalConfiguration().getValue('base_url')).host,
        port: Uri.parse(GlobalConfiguration().getValue('base_url')).port,
        path: _path + path);
    return uri;
  }

  Color getColorFromHex(String hex) {
    if (hex.contains('#')) {
      return Color(int.parse(hex.replaceAll("#", "0xFF")));
    } else {
      return Color(int.parse("0xFF" + hex));
    }
  }

  static String getPreviousIndex({List list, dynamic currentObject}) {
    if (list == null ||
        list.isEmpty ||
        list.indexOf(currentObject) == list.indexOf(list.first)) {
      return null;
    } else {
      var difference = list.indexOf(list.last) - list.indexOf(currentObject);
      return '${list.indexOf(list.last) - difference}';
    }
  }

  static String getNextIndex({List list, dynamic currentObject}) {
    if (list == null ||
        list.isEmpty ||
        list.indexOf(currentObject) == list.indexOf(list.last)) {
      return null;
    } else {
      var difference = list.indexOf(list.last) - list.indexOf(currentObject);
      return '${list.indexOf(list.last) + difference}';
    }
  }
}
