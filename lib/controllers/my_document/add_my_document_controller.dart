import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/repository/document_repo.dart';

class AddMyDocumentController extends ControllerMVC {
  Size size;
  List<String> documentType = [];
  String selectedType;
  DateTime currentDate = DateTime.now();
  String startDate = '';
  String expiryDate = '';
  File file;
  final picker = ImagePicker();
  String id;
  String documentName = '';
  bool isLoading = false;
  MultipartFile documentImage;
  String yearlyIncome = "";
  String personalTax = "";
  String maxTaxPercentage = "";

  void addFunction(context) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      if (selectedType == null) {
        toast('${Translations.of(context).pleaseSelectDocumentType}');
      } else if (selectedType == Translations.of(context).taxCard &&
          yearlyIncome.isEmpty) {
        toast('${Translations.of(context).enterValidYearlyIncome}');
      } else if (selectedType == Translations.of(context).taxCard &&
          personalTax.isEmpty) {
        toast('${Translations.of(context).enterValidPersonalTax}');
      } else if (selectedType == Translations.of(context).taxCard &&
          maxTaxPercentage.isEmpty) {
        toast('${Translations.of(context).enterValidMaxTaxPercentage}');
      } else if (startDate == "") {
        toast('${Translations.of(context).pleaseSelectStartDate}');
      } else if (documentName == "") {
        toast('${Translations.of(context).enterValidDocumentName}');
      } else if (expiryDate == "") {
        toast('${Translations.of(context).pleaseSelectExpiryDate}');
      } else if (file == null) {
        toast('${Translations.of(context).pleaseSelectFile}');
      } else {
        try {
          setState(() => isLoading = true);
          final response = await addMyDocApi(
            engSelectedType(context),
            yearlyIncome,
            personalTax,
            maxTaxPercentage,
            startDate,
            documentName,
            expiryDate,
            documentImage,
          );
          if (response.statusCode == 200) {
            Navigator.pop(context, true);
            setState(() => isLoading = false);
          } else {
            setState(() => isLoading = false);
            toast("${Translations.of(context).somethingWentToWrong}");
          }
        } catch (e) {
          print(e);
          setState(() => isLoading = false);
        }
      }
    } else {
      toast("${Translations.of(context).noInternetConnection}");
    }
  }

  void pickFile(context) async {
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
                      file = File(pickedFile.path);
                      setState(
                        () => documentImage = MultipartFile.fromFileSync(
                          file.path,
                          filename: path.basename(file.path),
                        ),
                      );
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
                    setState(() {
                      file = File(result.files.single.path);
                      documentImage = MultipartFile.fromFileSync(
                        file.path,
                        filename: path.basename(file.path),
                      );
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  engSelectedType(context) {
    if (selectedType == Translations.of(context).workSafetyCard) {
      return "Work Safety Card";
    }
    if (selectedType == Translations.of(context).taxCard) {
      return "Tax Card";
    }
    if (selectedType == Translations.of(context).idCard) {
      return "ID Card";
    }
    if (selectedType == Translations.of(context).passport) {
      return "Passport";
    }
    if (selectedType == Translations.of(context).drivingLicense) {
      return "Driving License";
    }
    if (selectedType == Translations.of(context).residencePermit) {
      return "Residence Permit";
    }
    if (selectedType == Translations.of(context).mycv) {
      return "My CV";
    }
    if (selectedType == Translations.of(context).otherDocuments) {
      return "Other Documents";
    }
  }
}
