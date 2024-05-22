import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:way_to_work/controllers/base_controller.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/my_document_model.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/pages/my_document/add_contract_file_screen.dart';
import 'package:way_to_work/pages/my_document/add_my_document_screen.dart';
import 'package:way_to_work/repository/document_repo.dart';

class MyDocumentController extends BaseController {
  Size size;
  bool isLoading = false;
  bool myDocumentExpanded = false;
  List<MyDocModel> docList = [];
  List<ContractModel> contractList = [];
  List<String> eContractList = [];
  String contractUrl = "";
  String docErrorText = "";
  List requiredParameter = [];
  List uploadedParameter = [];
  String myDocUrl = "";
  String eContractUrl = "";
  bool contractFileExpanded = false;
  bool eContractExpanded = false;

  void onMyDocumentTap() {
    setState(() => myDocumentExpanded = !myDocumentExpanded);
  }

  void onEContractTap() {
    setState(() => eContractExpanded = !eContractExpanded);
  }

  void onContractType() {
    setState(() => contractFileExpanded = !contractFileExpanded);
  }

  void addMyDocFun(context) async {
    var res = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddMyDocumentScreen()));
    if (res == true) {
      getDocumentList(context);
    }
  }

  void addContractFun(context) async {
    var res = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddContractByFileScreen()));
    if (res == true) {
      getContractList(context);
    }
  }

  void deleteMyDoc(id, fileName, context) async {
    try {
      setState(() => isLoading = true);
      Response response = await deleteMyDocApi(id, fileName);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, RouteKeys.MY_DOCUMENT_SCREEN);
        toast("${Translations.of(context).deletedSuccessfully}");
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        setState(() => isLoading = false);
        NetworkClass.internetNotConnection(response);
      } else {
        setState(() {
          isLoading = false;
        });
        toast("${Translations.of(context).somethingWentToWrong}");
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void deleteContractValue(id, fileName, context) async {
    try {
      setState(() => isLoading = true);
      Response response = await deleteContractApi(id, fileName);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, RouteKeys.MY_DOCUMENT_SCREEN);
        toast("${Translations.of(context).deletedSuccessfully}");
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        setState(() => isLoading = false);
        NetworkClass.internetNotConnection(response);
      } else {
        setState(() => isLoading = false);
        toast("${Translations.of(context).somethingWentToWrong}");
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void getDocumentList(context) async {
    try {
      setState(() => isLoading = true);
      Response response = await getMyDocListApi();
      if (response.statusCode == 200) {
        setState(() {
          requiredParameter = [];
          uploadedParameter = [];
          docList = [];
          isLoading = false;
        });
        var res = json.decode(response.body);
        res['my_document'].forEach((val) {
          setState(
            () => docList.add(
              MyDocModel(
                id: val['ID'],
                fileName: val['file_name'],
                title: val['document_name'],
                expiryDate: val['expire_date'],
                startDate: val['beginig_of_tax_card'],
                docType: val['document_type'],
                isDelete: val['is_delete'] == "true" ? true : false,
                isExpired: val['is_expired'] == "true" ? true : false,
                isExpanded: false,
              ),
            ),
          );
        });
        setState(() => myDocUrl = res['urls']['my_document_url']);
        res['required_documents_type'].forEach((val) {
          setState(() => requiredParameter.add(val));
        });
        res['all_uploaded_documents_types'].forEach((v) {
          if (requiredParameter.contains(v['document_type'])) {
            // setState(() => requiredParameter.remove(v['document_type']));
            setState(() => requiredParameter = []);
          }
        });
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        setState(() => isLoading = false);
        NetworkClass.internetNotConnection(response);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  transletType(context, type) {
    if (type == "Work Safety Card") {
      return Translations.of(context).workSafetyCard;
    }
    if (type == "Tax Card") {
      return Translations.of(context).taxCard;
    }
    if (type == "ID Card") {
      return Translations.of(context).idCard;
    }
    if (type == "Passport") {
      return Translations.of(context).passport;
    }
    if (type == "Driving License") {
      return Translations.of(context).drivingLicense;
    }
    if (type == "Residence Permit") {
      return Translations.of(context).residencePermit;
    }
    if (type == "My CV") {
      return Translations.of(context).mycv;
    }
    if (type == "Other Documents") {
      return Translations.of(context).otherDocuments;
    }
  }

  void getContractList(context) async {
    try {
      setState(() => isLoading = true);
      Response response = await getContractListApi();
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        setState(() {
          contractList = [];
          eContractList = [];
        });
        res['result_contracts'].forEach((val) {
          setState(
            () => contractList.add(
              ContractModel(
                id: val['ID'],
                contractName: val['contract_name'],
                documentName: val['document_name'],
                employerId: val['employer_id'],
                fileName: val['file_name'],
                expiryDate: val['expire_date'],
                isExpanded: false,
              ),
            ),
          );
        });
        res['e_contracts'].forEach((val) {
          setState(
            () => eContractList.add(
              val['ID'].toString(),
            ),
          );
        });
        setState(() {
          contractUrl = res['urls']['contracts_url'];
          eContractUrl = res['urls']['e_contracts_url'];
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        setState(() => isLoading = false);
        NetworkClass.internetNotConnection(response);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
}
