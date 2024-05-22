import 'dart:convert';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/employer_list_model.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/document_repo.dart';

class AddContractByFileController extends ControllerMVC {
  Size size;
  List<EmployerModel> employerList = [];
  EmployerModel selectedType;
  DateTime currentDate = DateTime.now();
  String expiryDate = '';
  File file;
  final picker = ImagePicker();
  String contractName = '';
  bool isLoading = false;

  void addFunction(context) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      if (selectedType == null) {
        toast('${Translations.of(context).pleaseSelectEmployer}');
      } else if (contractName.isEmpty) {
        toast('${Translations.of(context).enterValidFileName}');
      } else if (expiryDate == "") {
        toast('${Translations.of(context).pleaseSelectExpiryDate}');
      } else if (file == null) {
        toast('${Translations.of(context).pleaseSelectFile}');
      } else {
        try {
          setState(() => isLoading = true);
          final response = await addContractApi(
            selectedType.id,
            contractName,
            expiryDate,
            MultipartFile.fromFileSync(
              file.path,
              filename: path.basename(file.path),
            ),
          );
          if (response.statusCode == 200) {
            Navigator.pop(context, true);
            setState(() => isLoading = false);
          } else if (response.statusCode == 401) {
            setState(() => isLoading = false);
            NetworkClass.unAuthenticatedUser(context, response);
          } else {
            setState(() => isLoading = false);
            toast("${Translations.of(context).somethingWentToWrong}");
          }
        } catch (e) {
          setState(() => isLoading = false);
        }
      }
    } else {
      toast("${Translations.of(context).noInternetConnection}");
    }
  }

  void getEmployerList(context) async {
    try {
      setState(() => isLoading = true);
      http.Response response = await getContractEmployeeListApi();
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        setState(() => employerList = []);
        print(res.runtimeType);
        if (res[0] == 0 || res == null || res == []) {
          Navigator.pop(context);
          toast("${Translations.of(context).noEmployeeFound}");
        } else
          res.forEach((val) {
            setState(
              () => employerList.add(
                EmployerModel(
                  id: val['ID'],
                  companyName: val['first_name'],
                ),
              ),
            );
          });
        setState(() => isLoading = false);
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
                    setState(() => file = File(result.files.single.path));
                  }
                },
              ),
            ],
          );
        });
  }
}
