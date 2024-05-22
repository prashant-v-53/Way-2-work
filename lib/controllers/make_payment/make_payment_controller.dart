import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/controllers/base_controller.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/payment_invoice_model.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/employer_repo.dart';
import 'package:way_to_work/repository/manage_payment_repo.dart';

class MakePaymentInvoiceController extends BaseController {
  Size size;
  List<PaymentInvoice> paymentList = [];
  PaymentInvoice dropdownValue;
  bool isLoading = true;
  bool isAddPart = false;
  String mytax = "0";
  bool invoiceData = false;
  bool employerDetails = false;
  bool dailyWorkDetails = false;

  getPaymentList(context) async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(PrefsKey.USER_ID);
    if (prefs.getStringList('${uid}invoiceDraftList') != null) {
      prefs.getStringList('${uid}invoiceDraftList').forEach((element) {
        var res = json.decode(element);
        setState(() {
          paymentList.add(
            PaymentInvoice(
              contractType: res['contractType'],
              invoiceTotal:
                  res['invoiceTotal'] == "" ? "-" : res['invoiceTotal'],
              payToAcc: "-",
              contractValue: res['contractValue'],
              createdAt: "-",
              currency: "-",
              dueDate: res['dueDate'],
              employerId: res['employerId'],
              id: "Draft",
              invoiceReference: res['reference'],
              status: '0',
              paidStatus: "-",
              invoiceId: "-",
              invoiceNumber: "-",
              isDuplicate: "-",
              name: res['explanation'],
              seekerId: res['hoursId'],
              tax: res['taxPercentage'],
              vat: res['vat'],
              verified: "-",
            ),
          );
        });
      });
    }
    Response response = await ManagePaymentRepo.getPaymentListApi();
    if (response != null) {
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        log(decoded.toString());
        decoded['invoice']
            .forEach((json) => paymentList.add(PaymentInvoice.fromJSON(json)));
        prefs.setString(
          PrefsKey.TAX_PERCENTAGE,
          decoded['my_tax'],
        );

        if (paymentList.isNotEmpty)
          setState(() {
            dropdownValue = paymentList.first;
            mytax = decoded['my_tax'];
          });
        setState(() => isLoading = false);
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
    }
  }

  void deleteInvoiceItem(id, context) async {
    try {
      setState(() => isLoading = true);
      Response response = await removeInvoice(id);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(
            context, RouteKeys.MANAGE_PAYMENT_SCREEN);
        toast('${Translations.of(context).deletedSuccessfully}');
      } else if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          toast(decoded.first);
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
      setState(() => isLoading = false);
    }
  }

  void deleteInvoice(context, draftItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> invoiceDraftList = [];
    String uid = prefs.getString(PrefsKey.USER_ID);
    if (prefs.getStringList('${uid}invoiceDraftList') != null) {
      setState(
        () => invoiceDraftList = prefs.getStringList('${uid}invoiceDraftList'),
      );
    }
    var draftA = {
      "hoursId": draftItem.seekerId,
      "contractType": draftItem.contractType,
      "contractValue": draftItem.contractValue,
      "taxPercentage": draftItem.tax,
      "dueDate": draftItem.dueDate,
      "vat": draftItem.vat,
      "reference": draftItem.invoiceReference,
      "explanation": draftItem.name,
    };
    String data = json.encode(draftA);
    setState(() => invoiceDraftList.remove(data));
    prefs.setStringList("${uid}invoiceDraftList", invoiceDraftList);
    Navigator.pushReplacementNamed(context, RouteKeys.MANAGE_PAYMENT_SCREEN);
    toast("${Translations.of(context).deletedSuccessfully}");
  }

  invoiceDataSelected() {
    setState(() => invoiceData = !invoiceData);
  }

  dailyWorkDetailsSelected() {
    setState(() => dailyWorkDetails = !dailyWorkDetails);
  }

  employerDetailsSelected() {
    setState(() => employerDetails = !employerDetails);
  }

  onDropChange(value) {
    setState(() => dropdownValue = value);
  }

  onDuplicateFunction(id, context) async {
    setState(() => isLoading = true);
    Response response = await ManagePaymentRepo.duplicatePaymentList(id);
    if (response != null) {
      if (response.statusCode == 200) {
        setState(() => paymentList = []);
        getPaymentList(context);
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
    }
  }

  // prevInvoice() {
  //   var prevIndex = Helper.getPreviousIndex(list: paymentList, currentObject: dropdownValue);
  //   if (prevIndex != null ) {
  //     setState(() {
  //       dropdownValue = paymentList[int.parse(prevIndex) - 1];
  //     });
  //   } else {
  //     debugPrint('no data');
  //   }
  // }

  // nextInvoice() {
  //   var nextIndex = Helper.getNextIndex(list: paymentList, currentObject: dropdownValue);
  //   if (nextIndex != null ) {
  //     setState(() {
  //       dropdownValue = paymentList[int.parse(nextIndex) - 1];
  //     });
  //   } else {
  //     debugPrint('no data');
  //   }
  // }
}
