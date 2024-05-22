import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/month_list_model.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/account_repo.dart';

class ManageAccountController extends ControllerMVC {
  Size size;
  bool isLoading = false;
  List<MonthModel> dobMonthList = [
    MonthModel(id: 1, name: "Jan"),
    MonthModel(id: 2, name: "Feb"),
    MonthModel(id: 3, name: "Mar"),
    MonthModel(id: 4, name: "Apr"),
    MonthModel(id: 5, name: "May"),
    MonthModel(id: 6, name: "Jun"),
    MonthModel(id: 7, name: "Jul"),
    MonthModel(id: 8, name: "Aug"),
    MonthModel(id: 9, name: "Sep"),
    MonthModel(id: 10, name: "Oct"),
    MonthModel(id: 11, name: "Nov"),
    MonthModel(id: 12, name: "Dec"),
  ];
  List<String> genderList = ['Male', 'Female'];
  String gender;
  List countryList = [];
  List nationalityList = [];
  String firstName,
      lastName,
      currentAddress,
      country,
      city,
      nationality,
      mobileNo,
      phoneNo,
      personalTax,
      maxTaxPercenatge,
      yearlyIncome,
      bankName,
      accountNumber,
      bic,
      bruttoSalary,
      bulkAmount,
      earnedSoFar;

  int dobDate, dobYear;
  MonthModel dobMonth;

  void getAccountDetails(context) async {
    try {
      setState(() => isLoading = true);
      Response response = await getProfileAccApi();
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        log(decoded.toString());
        countryList = [];
        nationalityList = [];
        String sex = decoded['row']['gender'];
        String fullDate = decoded['row']['dob'];
        if (fullDate != null) {
          String day = fullDate.split('-')[2];
          String mon = fullDate.split('-')[1];
          String year = fullDate.split('-')[0];
          dobMonthList.forEach((month) {
            if (month.id == int.parse(mon)) {
              setState(() => dobMonth = month);
            }
          });
          setState(() {
            dobDate = int.parse(day);
            dobYear = int.parse(year);
          });
        }
        genderList.forEach((element) {
          if (sex != null) {
            if (element == "${sex[0].toUpperCase()}${sex.substring(1)}") {
              setState(() => gender = element);
            }
          }
        });
        decoded['result_countries'].forEach((val) {
          setState(() {
            countryList.add(val['country_name']);
            nationalityList.add(val['country_citizen']);
            if (val['country_name'] == decoded['row']['country']) {
              country = decoded['row']['country'];
            }
            if (val['country_citizen'] == decoded['row']['nationality']) {
              nationality = decoded['row']['nationality'];
            }
          });
        });
        setState(() {
          firstName =
              "${decoded['row']['first_name'][0].toUpperCase() + decoded['row']['first_name'].substring(1)}";
          lastName = decoded['row']['last_name'] == null ||
                  decoded['row']['last_name'] == ""
              ? ""
              : "${decoded['row']['last_name'][0].toUpperCase() + decoded['row']['last_name'].substring(1)}";
          currentAddress = decoded['row']['present_address'] == null
              ? ""
              : decoded['row']['present_address'].toString();
          city = decoded['row']['city'] == null
              ? ""
              : decoded['row']['city'].toString();
          mobileNo = decoded['row']['mobile'] == null
              ? ""
              : decoded['row']['mobile'].toString();
          phoneNo = decoded['row']['home_phone'] == null
              ? ""
              : decoded['row']['home_phone'].toString();
          personalTax = decoded['row']['personal_tax_number'] == null ||
                  decoded['row']['personal_tax_number'] == "null"
              ? ""
              : decoded['row']['personal_tax_number'].toString();
          maxTaxPercenatge = decoded['row']['max_tax_percentage'] == null ||
                  decoded['row']['max_tax_percentage'] == "null"
              ? ""
              : decoded['row']['max_tax_percentage'].toString();
          yearlyIncome = decoded['row']['total_yearly_income'] == null ||
                  decoded['row']['total_yearly_income'] == "null"
              ? ""
              : decoded['row']['total_yearly_income'].toString();
          bankName = decoded['row']['bank_name'] == null
              ? ""
              : decoded['row']['bank_name'];
          accountNumber = decoded['row']['account_number'] == null
              ? ""
              : decoded['row']['account_number'].toString();
          bic = decoded['row']['bic_number'] == null
              ? ""
              : decoded['row']['bic_number'].toString();
          bulkAmount = decoded['row']['income'] == null
              ? ""
              : decoded['row']['income'].toString();
          bruttoSalary = decoded['row']['gross_salary'] == null
              ? ""
              : decoded['row']['gross_salary'].toString();
          earnedSoFar = decoded['row']['earned_so_far'] == null
              ? ""
              : decoded['row']['earned_so_far'].toString();
          isLoading = false;
        });
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
      print(e);
      print("---");
      setState(() => isLoading = false);
    }
  }

  validateInput(context) {
    if (firstName == null || firstName.isEmpty) {
      toast("${Translations.of(context).enterValidFirstName}");
      return false;
    } else if (lastName == null || lastName.isEmpty) {
      toast("${Translations.of(context).enterValidLastName}");
      return false;
    } else if (gender == null) {
      toast("${Translations.of(context).selectGender}");
      return false;
    } else if (dobDate == null || dobMonth == null || dobYear == null) {
      toast("${Translations.of(context).pleaseSelectDate}");
      return false;
    } else if (currentAddress == null || currentAddress.isEmpty) {
      toast("${Translations.of(context).enterValidCurrentAddress}");
      return false;
    } else if (country == null) {
      toast("${Translations.of(context).pleaseSelectCountry}");
      return false;
    } else if (city == null || city.isEmpty) {
      toast("${Translations.of(context).enterValidCity}");
      return false;
    } else if (mobileNo == null || mobileNo.isEmpty) {
      toast("${Translations.of(context).enterMobileNo}");
      return false;
    } else {
      return true;
    }
  }

  void updateAccountInfo(context) async {
    try {
      setState(() => isLoading = true);
      Response response = await editProfileAccInfoApi(
        firstName,
        lastName,
        mobileNo,
        phoneNo,
        dobYear,
        dobMonth.id,
        dobDate,
        currentAddress,
        country,
        nationality,
        city,
        personalTax,
        maxTaxPercenatge,
        yearlyIncome,
        bankName,
        accountNumber,
        bic,
        gender,
        earnedSoFar,
      );
      if (response.statusCode == 200) {
        toast('${Translations.of(context).updatedSuccessfully}');
        Navigator.pop(context, true);
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        print(decoded);
        if (decoded.containsKey('first_name')) {
          toast(decoded['first_name']);
        }
        if (decoded.containsKey('last_name')) {
          toast(decoded['last_name']);
        }
        if (decoded.containsKey('mobile_number')) {
          toast(decoded['mobile_number']);
        }
        if (decoded.containsKey('dob_day')) {
          toast(decoded['dob_day']);
        }
        if (decoded.containsKey('dob_month')) {
          toast(decoded['dob_month']);
        }
        if (decoded.containsKey('dob_year')) {
          toast(decoded['dob_year']);
        }
        if (decoded.containsKey('gender')) {
          toast(decoded['gender']);
        }
        if (decoded.containsKey('present_address')) {
          toast(decoded['present_address']);
        }
        if (decoded.containsKey('country')) {
          toast(decoded['country']);
        }
        if (decoded.containsKey('city')) {
          toast(decoded['city']);
        }
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
      print(e);
      setState(() => isLoading = false);
    }
  }
}
