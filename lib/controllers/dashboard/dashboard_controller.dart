import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/models/dashboard_models.dart';
import 'package:way_to_work/repository/employer_repo.dart';
import 'package:way_to_work/repository/dashboard_repo.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class DashboardController extends ControllerMVC {
  bool isLoading = false;
  Size size;
  String inviteCount = '';
  String invoiceCount = '';
  String numberOfWorkedHours = '';
  bool isInsuranceExpanded = false;
  dynamic incomePercentage;
  bool isGeneralInfoExpanded = false;
  List<InsuranceServiceModel> insuranceServiceList = [];
  List<ReceiveDocumentModel> receiveDocumentList = [];
  ProfileModel profileModel;
  String profileUrl;
  String sendInviteUrl = "";
  String receiveDocUrl;
  File profileImage;
  final picker = ImagePicker();

  void generalInfoExpanded() {
    setState(() => isGeneralInfoExpanded = !isGeneralInfoExpanded);
  }

  void insuranceExpanded() {
    setState(() => isInsuranceExpanded = !isInsuranceExpanded);
  }

  void getPaySlipSummeryDetails(context) async {
    Response response = await getPaySlipSummeryApi();
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() => incomePercentage = decoded['income_percent_round']);
    } else if (response.statusCode == 400) {
      var decoded = jsonDecode(response.body);
      toast(decoded['error']);
    } else if (response.statusCode == 401) {
      NetworkClass.unAuthenticatedUser(context, response);
    } else if (response.statusCode == 503) {
      NetworkClass.internetNotConnection(response);
    }
  }

  void getDashboard(context) async {
    try {
      setState(() => isLoading = true);
      Response response = await getDashboardApi();
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        log(decoded["url"].toString());
        setState(() {
          isLoading = false;
          profileUrl = decoded['photo'];
          sendInviteUrl = decoded["url"].toString();
          receiveDocUrl = decoded['receive_doc_url'];
        });
        if (decoded['insurances'] != []) {
          decoded['insurances'].forEach((val) {
            setState(() {
              insuranceServiceList.add(
                InsuranceServiceModel(
                  id: val['id'],
                  insuranceService: val['insurance_name'],
                  insuranceEmail: val['insurance_email'],
                  action: val['status'],
                  insuranceNumber: val['insurance_number'],
                  package: val['insurance_packages'],
                  website: val['insurance_website'],
                  isExpanded: false,
                ),
              );
            });
          });
        }
        if (decoded['rcvd_doc'] != []) {
          decoded['rcvd_doc'].forEach((val) {
            setState(() {
              receiveDocumentList.add(
                ReceiveDocumentModel(
                  id: val['id'],
                  description: val['description'],
                  sentOn: val['sent_on'],
                  title: val['title'],
                  fileName: val['file_name'],
                  isExpanded: false,
                ),
              );
            });
          });
        }
        setState(() {
          numberOfWorkedHours = decoded['total_hours'] == null
              ? "0"
              : decoded['total_hours'].toString();
          invoiceCount = decoded['total_invoice'].toString();
          inviteCount = decoded['invite_count'] == null
              ? "0"
              : decoded['invite_count']['count'].toString();
          profileModel = ProfileModel(
            id: decoded['auth_user_details']['ID'].toString(),
            name:
                "${decoded['auth_user_details']['first_name'][0].toUpperCase() + decoded['auth_user_details']['first_name'].substring(1)} ${decoded['auth_user_details']['last_name'] == null || decoded['auth_user_details']['last_name'] == "" ? "" : decoded['auth_user_details']['last_name'][0].toUpperCase() + decoded['auth_user_details']['last_name'].substring(1)}",
            email: decoded['auth_user_details']['email'],
            city: decoded['auth_user_details']['city'] == null
                ? ""
                : decoded['auth_user_details']['city'],
            country: decoded['auth_user_details']['country'] == null
                ? ""
                : decoded['auth_user_details']['country'],
            mobileNo: decoded['auth_user_details']['mobile'] == null
                ? ""
                : decoded['auth_user_details']['mobile'],
            ssn: decoded['auth_user_details']['ssn'],
            taxNo: decoded['auth_user_details']['tax_number'],
            dob: decoded['auth_user_details']['dob'] == null
                ? ""
                : decoded['auth_user_details']['dob'],
          );
        });
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
        Navigator.pop(context);
        NetworkClass.internetNotConnection(response);
        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void uploadImageFun(context, multipartFile) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      if (profileImage == null) {
        toast("${Translations.of(context).noImageSelected}");
      } else {
        setState(() => isLoading = true);
        d.Response response = await uploadProfileImageApi(multipartFile);
        setState(() => isLoading = false);
        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, RouteKeys.DASHBOARD);
          setState(() => isLoading = false);
        } else if (response.statusCode == 401) {
          setState(() => isLoading = false);
          NetworkClass.unAuthenticatedUser(context, response);
        } else {
          setState(() => isLoading = false);
          toast("${Translations.of(context).somethingWentToWrong}");
        }
      }
    } else {
      toast("${Translations.of(context).noInternetConnection}");
    }
  }

  void deleteImageFunction(context) async {
    setState(() => isLoading = true);
    Response response = await deleteProfileImageApi();
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, RouteKeys.DASHBOARD);
      setState(() => isLoading = false);
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
  }

  void pickProfileFile(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("${Translations.of(context).camera}"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await picker.getImage(source: ImageSource.camera);
                  setState(() {
                    if (pickedFile != null) {
                      profileImage = File(pickedFile.path);
                      var multiPartFile = d.MultipartFile.fromFileSync(
                          profileImage.path,
                          filename: path.basename(profileImage.path));
                      uploadImageFun(context, multiPartFile);
                    } else {
                      toast('${Translations.of(context).noImageSelected}');
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text("${Translations.of(context).file}"),
                onTap: () async {
                  Navigator.pop(context);
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(
                        () => profileImage = File(result.files.single.path));
                    var multiPartFile = d.MultipartFile.fromFileSync(
                        profileImage.path,
                        filename: path.basename(profileImage.path));
                    uploadImageFun(context, multiPartFile);
                  }
                },
              ),
            ],
          );
        });
  }
}
