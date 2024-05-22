import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/helper.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/employer_repo.dart';

class AddEmployerDetailsController extends ControllerMVC {
  Size size;
  String email = '';
  String id;
  String phone = '';
  List<String> dropdownList = [];
  String dropdownValue;
  String tax = '';
  String yTunnus = '';
  String address = '';
  String ssn = '';
  String employName = '';
  String companyName = '';
  bool isLoading = false;

  bool validateEmail() {
    if (email.isEmpty || !Helper.isEmail(email)) {
      return true;
    }
    return false;
  }

  initializeFields(context) {
    setState(() {
      dropdownList = [
        "${Translations.of(context).company}",
        "${Translations.of(context).client}",
      ];
      dropdownValue = "${Translations.of(context).company}";
    });
  }

  void setEmployerDetails(empId, context) async {
    setState(() => isLoading = true);
    try {
      Response response = await getEmployerDetailsApi(empId);
      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        var decoded = jsonDecode(response.body);
        setState(() {
          id = empId;
          employName = decoded['name'];
          phone = decoded['comp_mobile'];
          email = decoded['email'];
          yTunnus = decoded['ytunnus'];
          ssn = decoded['ssn'];
          tax = decoded['tax'];
          address = decoded['comp_address'];
          companyName = decoded['company_name'];
          dropdownValue = decoded['company_name'] != "" ? "${Translations.of(context).company}" : "${Translations.of(context).client}";
        });
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        toast(decoded['error']);
        setState(() => isLoading = false);
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        setState(() => isLoading = false);
        NetworkClass.internetNotConnection(response);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void addEmployeDetailsFunction(context) async {
    if (dropdownValue == "${Translations.of(context).company}" &&
            yTunnus.isEmpty ||
        dropdownValue != "${Translations.of(context).company}" && ssn.isEmpty) {
      toast("${Translations.of(context).eitherSSNorYTunnusShouldBeprovided}");
    } else if (validateEmail()) {
      toast('${Translations.of(context).enterValidEmail}');
    } else {
      try {
        setState(() => isLoading = true);
        Response response = await addEmployerApi(
          dropdownValue == "${Translations.of(context).company}"
              ? ""
              : employName,
          phone,
          dropdownValue == "${Translations.of(context).company}" ? yTunnus : "",
          dropdownValue == "${Translations.of(context).company}" ? "" : ssn,
          tax,
          address,
          email,
          dropdownValue == "${Translations.of(context).company}"
              ? companyName
              : "",
        );
        if (response.statusCode == 200) {
          Navigator.pop(context, true);
          setState(() => isLoading = false);
        } else if (response.statusCode == 400) {
          setState(() => isLoading = false);
          var decoded = jsonDecode(response.body);
          if (decoded is List) {
            toast(decoded.first);
          } else {
            if (decoded.containsKey('anonim_name')) {
              toast(decoded['anonim_name']);
            }
            if (decoded.containsKey('anonim_telephone')) {
              toast(decoded['anonim_telephone']);
            }
            if (decoded.containsKey('anonim_email')) {
              toast(decoded['anonim_email']);
            }
            if (decoded.containsKey('anonim_address')) {
              toast(decoded['anonim_address']);
            }
            if (decoded.containsKey('anonim_ssn')) {
              toast(decoded['anonim_ssn']);
            }
            if (decoded.containsKey('anonim_ytunnus')) {
              toast(decoded['anonim_ytunnus']);
            }
          }
        } else if (response.statusCode == 401) {
          setState(() => isLoading = false);
          NetworkClass.unAuthenticatedUser(context, response);
        } else if (response.statusCode == 503) {
          setState(() => isLoading = false);
          NetworkClass.internetNotConnection(response);
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }

  void editWorkDetailsFunction(context) async {
    if (dropdownValue == "${Translations.of(context).company}" &&
            yTunnus.isEmpty ||
        dropdownValue != "${Translations.of(context).company}" && ssn.isEmpty) {
      toast("${Translations.of(context).eitherSSNorYTunnusShouldBeprovided}");
    } else if (validateEmail()) {
      toast('${Translations.of(context).enterValidEmail}');
    } else {
      try {
        setState(() => isLoading = true);
        Response response = await editEmployerApi(
          id,
          dropdownValue == "${Translations.of(context).company}"
              ? ""
              : employName,
          phone,
          dropdownValue == "${Translations.of(context).company}" ? yTunnus : "",
          dropdownValue == "${Translations.of(context).company}" ? "" : ssn,
          tax,
          address,
          email,
          dropdownValue == "${Translations.of(context).company}"
              ? companyName
              : "",
        );
        if (response.statusCode == 200) {
          var decoded = jsonDecode(response.body);
          print('decoded$decoded');
          Navigator.pop(context, true);
          setState(() => isLoading = false);
        } else if (response.statusCode == 400) {
          setState(() => isLoading = false);
          var decoded = jsonDecode(response.body);
          print('decoded$decoded');
          if (decoded is List) {
            toast(decoded.first);
          } else {
            if (decoded.containsKey('anonim_name')) {
              toast(decoded['anonim_name']);
            }
            if (decoded.containsKey('anonim_telephone')) {
              toast(decoded['anonim_telephone']);
            }
            if (decoded.containsKey('anonim_email')) {
              toast(decoded['anonim_email']);
            }
            if (decoded.containsKey('anonim_address')) {
              toast(decoded['anonim_address']);
            }
            if (decoded.containsKey('anonim_ssn')) {
              toast(decoded['anonim_ssn']);
            }
            if (decoded.containsKey('anonim_ytunnus')) {
              toast(decoded['anonim_ytunnus']);
            }
          }
        } else if (response.statusCode == 401) {
          setState(() => isLoading = false);
          NetworkClass.unAuthenticatedUser(context, response);
        } else if (response.statusCode == 503) {
          setState(() => isLoading = false);
          NetworkClass.internetNotConnection(response);
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }
}
