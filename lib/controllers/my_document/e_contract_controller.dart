import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:way_to_work/controllers/base_controller.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/document_repo.dart';

class EControllerController extends BaseController {
  Size size;
  String companyName,
      createdOn,
      employer,
      yTunnus,
      employerEmail,
      employerNumber,
      lightEnterpreneurName,
      lightEnterpreneurNationality,
      lightEnterpreneurEmail,
      lightEnterpreneurPhone,
      lightEnterpreneurTaxNumber,
      lightEnterpreneurSSN,
      lightEnterpreneurBillingAddress,
      invoicingEmail,
      workSiteAddress,
      refNumber,
      beginningOfWork,
      workFinishedOn,
      billingInterval,
      otherInfo,
      invoicingBy,
      contractType,
      contractValue,
      otherInfo2,
      foodType,
      foodValue,
      travellingType,
      travellingValue,
      workDescription,
      termsAndcondition,
      acceptByLightEnterpreneur,
      employerSignature,
      lightEnterpreneurSignature;
  bool isLoading = false;
  Uint8List employerSignatureImage;
  Uint8List employeeSignatureImage;

  void getEContractList(id, context) async {
    try {
      setState(() => isLoading = true);
      http.Response response = await getEContractApi(id);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        log(res.toString());
        setState(() {
          isLoading = false;
          companyName = res['employer_data'] == 0 || res['employer_data'] == null
              ? ""
              : res['employer_data']['company_name'];
          createdOn = DateFormat('d:M:y').format(
              DateFormat("yyyy-MM-dd HH:mm:ss")
                  .parse(res['contract_details']['created_on']));
          employer = res['employer_data'] == 0 || res['employer_data'] == null
              ? ""
              : res['employer_data']['first_name'];
          yTunnus = res['contract_details']['ytunus'];
          employerEmail = res['contract_details']['employer_email'];
          employerNumber = res['contract_details']['employer_phone'];
          lightEnterpreneurName = res['employee_data'] == null
              ? ""
              : res['employee_data']['first_name'];
          lightEnterpreneurNationality = res['employee_data'] == null
              ? ""
              : res['employee_data']['nationality'];
          lightEnterpreneurEmail = res['contract_details']['employee_email'];
          lightEnterpreneurPhone = res['contract_details']['employee_phone'];
          lightEnterpreneurTaxNumber = res['employee_data'] == null
              ? ""
              : res['employee_data']['tax_number'];
          lightEnterpreneurSSN =
              res['employee_data'] == null ? "" : res['employee_data']['ssn'];
          lightEnterpreneurBillingAddress =
              res['contract_details']['employee_billing_address'];
          invoicingEmail = res['contract_details']['employee_invoicing_email'];
          workSiteAddress = res['contract_details']['employee_worksite_adress'];
          refNumber = res['contract_details']['employee_referrance_number'];
          beginningOfWork = res['contract_details']['employee_work_beginning'];
          workFinishedOn = res['contract_details']['employee_work_finished'];
          billingInterval =
              res['contract_details']['employee_billing_interval'];
          otherInfo = res['contract_details']['employee_other_information'];
          invoicingBy = res['contract_details']['employee_other_information'];
          contractType = res['contract_details']['employee_salary_type'];
          contractValue = res['contract_details']['employee_salary_value'];
          otherInfo2 = res['contract_details']['employee_other_expenses'];
          foodType = res['food_settings']['food_type'];
          foodValue = res['contract_details']['employee_food_value'];
          travellingType = res['travel_settings']['setting_type'];
          travellingValue = res['contract_details']['employee_travel_value'];
          workDescription =
              res['contract_details']['employee_work_description'];
          termsAndcondition = res['tems_and_conditions_text'];
          acceptByLightEnterpreneur =
              res['contract_details']['accepted_by_employee'];
          employerSignatureImage =
              res['contract_details']['employers_signature_file'] == "NULL"
                  ? null
                  : Base64Decoder().convert(res['contract_details']
                          ['employers_signature_file']
                      .split(',')
                      .last);
          employeeSignatureImage =
              res['contract_details']['employee_signature_file'] == "NULL"
                  ? null
                  : Base64Decoder().convert(res['contract_details']
                          ['employee_signature_file']
                      .split(',')
                      .last);
        });
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        Navigator.pop(context);
        NetworkClass.internetNotConnection(response);
        setState(() => isLoading = false);
      } else {
        Navigator.pop(context);
        toast('${Translations.of(context).somethingWentToWrong}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }
}
