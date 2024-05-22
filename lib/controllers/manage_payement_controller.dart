import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/controllers/base_controller.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/employer_list_model.dart';
import 'package:way_to_work/models/invoice_model.dart';
import 'package:way_to_work/models/worked_hour_model.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/pages/dashboard/add_work_detail_screen.dart';
import 'package:way_to_work/pages/manage_payment/add_new_employer_screen.dart';
import 'package:way_to_work/repository/employer_repo.dart';
import 'package:way_to_work/repository/manage_payment_repo.dart';
import 'package:way_to_work/repository/worked_hours_repo.dart';

class ManagePaymentController extends BaseController {
  Size size;
  bool isAddPart = false;
  bool isLoading = false;
  bool invoiceData = false;
  bool employerDetails = false;
  List<String> typesList = ["Hours", "Pieces"];
  List hoursIds = [];
  List<WorkedHourModel> dailyWOrkDetailsList = [];
  WorkedHourModel workData;
  final picker = ImagePicker();
  List<String> dueDateList = [];
  List<String> vatList = [];
  String personalTax = "0";
  String selectedType = 'Hours';
  bool dailyWorkDetails = false;
  String name = '',
      nameCompany = "",
      telephone = '',
      email = '',
      yTunnus = '',
      ssn = '',
      taxNo = '',
      address = '',
      type = '';
  File receiptFile;
  File otherExpensesFile;
  File otherFile;
  List<File> multipleFileList = [];
  List<MultipartFile> multipleMultipartFiles = [];
  List<InvoiceModel> invoiceList = [];
  List<EmployerModel> employerList = [];
  EmployerModel currentEmployer;
  double totalContractValue = 0;
  String payToAccount;
  String contractValue = '',
      dueDate = '',
      vat = '',
      reference = '',
      explanation = '';

  String draftArray;

  invoiceDataSelected() {
    setState(() {
      invoiceData = !invoiceData;
      dailyWorkDetails = false;
      employerDetails = false;
    });
  }

  dailyWorkDetailsSelected() {
    setState(() {
      dailyWorkDetails = !dailyWorkDetails;
      invoiceData = false;
      employerDetails = false;
    });
  }

  employerDetailsSelected() {
    setState(() {
      employerDetails = !employerDetails;
      invoiceData = false;
      dailyWorkDetails = false;
    });
  }

  void addEmployeFunction(context) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNewEmployerScreen(
          id: null,
        ),
      ),
    );
    if (res == true) {
      setState(() {
        employerList = [];
        getEmployerList(context);
        employerDetails = false;
        dailyWorkDetails = true;
      });
    }
  }

  void editHours(context, val) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddWorkDetailScreen(
          data: val,
          fromManagePayment: true,
          firstTime: false,
          type: val.type,
        ),
      ),
    );

    if (res != null) {
      setState(() {
        dailyWOrkDetailsList.remove(val);
        dailyWOrkDetailsList.add(res);
        workData = dailyWOrkDetailsList[0];
        selectedType = dailyWOrkDetailsList[0].type;
        getTotalAmount();
      });
    }
  }

  getTotalAmount() {
    totalContractValue = 0.0;
    dailyWOrkDetailsList.forEach((element) {
      if (element?.workingHours != null && element.workingHours.isNotEmpty) {
        totalContractValue =
            totalContractValue + double.parse(element.workingHours);
      }
    });
  }

  void onDuplicateWorkedHoursFun(date, id, context) async {
    try {
      setState(() => isLoading = true);
      http.Response response = await onDuplicateAPI(date, id);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        WorkedHourModel hour = WorkedHourModel(
          id: decoded['id'].toString(),
          date: decoded['date'],
          km: decoded['km'].toString(),
          dailyCompansations: decoded['daily_allow'].toString(),
          dayCompansations: decoded['full_day_compensations'].toString(),
          extraInformation: decoded['extra_information'].toString(),
          fullDate: decoded['created_at'],
          otherCompensation: decoded['other_comp'].toString(),
          tripAddress: decoded['trip_address'].toString(),
          tripEnd: decoded['trip_end'],
          tripStart: decoded['trip_start'],
          workingHours: decoded['total_hours'].toString(),
          tripTime: decoded['total_trip_time'].toString(),
          type: decoded['contract_type'],
        );
        setState(() {
          dailyWOrkDetailsList.add(hour);
          workData = dailyWOrkDetailsList[0];
          selectedType = dailyWOrkDetailsList[0].type;
          getTotalAmount();
          isLoading = false;
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
        setState(() => isLoading = false);
        NetworkClass.internetNotConnection(response);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void deleteWorkedHoursFromManagePayment(context) async {
    try {
      setState(() => isLoading = true);
      http.Response response = await deleteWorkedHoursApi(workData.id);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          dailyWOrkDetailsList.remove(workData);
          workData = dailyWOrkDetailsList[0];
          getTotalAmount();
        });
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

  void addHours(context, fromManagePayment) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddWorkDetailScreen(
          data: null,
          fromManagePayment: true,
          firstTime: dailyWOrkDetailsList.length == 0 ? true : false,
          type: dailyWOrkDetailsList.length == 0
              ? 'Hours'
              : dailyWOrkDetailsList[0].type,
        ),
      ),
    );
    if (res != null) {
      setState(() {
        dailyWOrkDetailsList.add(res);
        workData = dailyWOrkDetailsList[0];
        selectedType = dailyWOrkDetailsList[0].type;
        getTotalAmount();
      });
    }
  }

  void pickReceiptFile(context) async {
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
                      receiptFile = File(pickedFile.path);
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
                        () => receiptFile = File(result.files.single.path));
                  }
                },
              ),
            ],
          );
        });
  }

  void pickMultipleFiles(context) async {
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
                      File fileImage = File(pickedFile.path);
                      multipleFileList.add(fileImage);
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
                      await FilePicker.platform.pickFiles(allowMultiple: true);
                  if (result != null) {
                    setState(() => multipleFileList =
                        result.paths.map((path) => File(path)).toList());
                  }
                },
              ),
            ],
          );
        });
  }

  void editEmployeFunction(context, iD) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNewEmployerScreen(
          id: iD,
        ),
      ),
    );
    if (res == true) {
      setState(() {
        employerList = [];
        getEmployerList(context);
        employerDetails = false;
        dailyWorkDetails = true;
      });
    }
  }

  void getEmployerList(context) async {
    try {
      setState(() => isLoading = true);
      http.Response response = await getEmployerListApi();
      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        var decoded = jsonDecode(response.body);
        print(decoded);
        if (decoded != []) {
          employerList.clear();
          decoded.forEach((val) {
            setState(() {
              employerList.add(
                EmployerModel(
                  id: val['ID'],
                  companyName: val['company_name'],
                  companyType: val['company_type'],
                ),
              );
            });
          });
          if (employerList.isNotEmpty) {
            setState(() => currentEmployer = employerList[0]);
            getEmployerDetails(currentEmployer.id, context);
          }
        }
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

  void getWorkedHoursForDraft(ids, context) async {
    try {
      setState(() => isLoading = true);
      http.Response response = await getDraftWorkedHours(ids);
      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        var decoded = jsonDecode(response.body);
        if (decoded != []) {
          setState(() => dailyWOrkDetailsList = []);
          decoded.forEach((val) {
            setState(() {
              dailyWOrkDetailsList.add(
                WorkedHourModel(
                  id: val['id'],
                  date: val['date'],
                  km: val['km'] == null ? '' : val['km'],
                  dailyCompansations:
                      val['daily_allow'] == null ? '' : val['daily_allow'],
                  dayCompansations: val['full_day_compensations'] == null
                      ? ''
                      : val['full_day_compensations'],
                  extraInformation: val['extra_information'] == null
                      ? ''
                      : val['extra_information'],
                  fullDate: val['created_at'] == null ? '' : val['created_at'],
                  otherCompensation:
                      val['other_comp'] == null ? '' : val['other_comp'],
                  tripAddress:
                      val['trip_address'] == null ? '' : val['trip_address'],
                  tripEnd: val['trip_end'] == null ? '' : val['trip_end'],
                  tripStart: val['trip_start'] == null ? '' : val['trip_start'],
                  workingHours:
                      val['total_hours'] == null ? '' : val['total_hours'],
                  tripTime: val['total_trip_time'] == null
                      ? ''
                      : val['total_trip_time'],
                  type:
                      val['contract_type'] == null ? '' : val['contract_type'],
                ),
              );
            });
          });
          if (dailyWOrkDetailsList.isNotEmpty) {
            setState(() => workData = dailyWOrkDetailsList[0]);
          }
        } else {
          setState(() => isAddPart = false);
        }
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

  void getEmployerDetails(id, context) async {
    try {
      http.Response response = await getEmployerDetailsApi(id);
      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        var decoded = jsonDecode(response.body);
        print(decoded);
        setState(() {
          name = decoded['name'];
          nameCompany = decoded['company_name'];
          telephone = decoded['comp_mobile'];
          email = decoded['email'];
          yTunnus = decoded['ytunnus'];
          ssn = decoded['ssn'];
          taxNo = decoded['tax'];
          address = decoded['comp_address'];
          type = decoded['type'];
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

  void deleteEmployerDetails(id, context) async {
    try {
      setState(() => isLoading = true);
      http.Response response = await deleteEmployerApi(id);
      print(response.statusCode);
      print(response.body);
      var decoded = jsonDecode(response.body);
      print(decoded);
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        print(decoded);
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

  void addInvoiceFun(ids, context, draftItem) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> invoiceDraftList = [];
      String uid = prefs.getString(PrefsKey.USER_ID);
      if (prefs.getStringList('${uid}invoiceDraftList') != null) {
        setState(
          () =>
              invoiceDraftList = prefs.getStringList('${uid}invoiceDraftList'),
        );
      }
      if (contractValue.isEmpty || int.parse(contractValue) == 0) {
        toast('${Translations.of(context).enterContractValue}');
      } else {
        if (multipleFileList.isNotEmpty) {
          multipleFileList.forEach((image) {
            multipleMultipartFiles.add(
              MultipartFile.fromFileSync(
                image.path,
                filename: path.basename(image.path),
              ),
            );
          });
        }
        try {
          setState(() => isLoading = true);
          final response = await ManagePaymentRepo.addNewPaymentApi(
            ids.join(', '),
            currentEmployer.id,
            selectedType,
            contractValue,
            personalTax,
            dueDate.replaceAll(
                ' ${Translations.of(context).days.toLowerCase()}', ""),
            vat,
            receiptFile == null
                ? null
                : MultipartFile.fromFileSync(receiptFile.path,
                    filename: path.basename(receiptFile.path)),
            // otherExpensesFile == null
            //     ? null
            //     : MultipartFile.fromFileSync(otherExpensesFile.path,
            //         filename: path.basename(otherExpensesFile.path)),
            // otherFile == null
            //     ? null
            //     : MultipartFile.fromFileSync(otherFile.path,
            //         filename: path.basename(otherFile.path)),
            multipleMultipartFiles.isEmpty ? null : multipleMultipartFiles,
            reference,
            explanation,
          );
          if (response.statusCode == 200) {
            if (invoiceDraftList.contains(draftItem)) {
              setState(() {
                invoiceDraftList.remove(draftItem);
              });
            }
            Navigator.pushReplacementNamed(
                context, RouteKeys.MANAGE_PAYMENT_SCREEN);
            toast('${Translations.of(context).invoiceCreatedSuccessfully}');
            setState(() => isLoading = false);
          } else if (response.statusCode == 400) {
            setState(() => isLoading = false);
            if (response.data.containsKey('contract_value')) {
              toast(response.data['contract_value']);
            }
          } else {
            setState(() => isLoading = false);
          }
        } catch (e) {
          setState(() => isLoading = false);
        }
      }
    } else {
      toast("${Translations.of(context).noInternetConnection}");
    }
  }

  void saveAsDraftFun(ids, context, draftItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> invoiceDraftList = [];
    String uid = prefs.getString(PrefsKey.USER_ID);
    if (prefs.getStringList('${uid}invoiceDraftList') != null) {
      setState(
        () => invoiceDraftList = prefs.getStringList('${uid}invoiceDraftList'),
      );
    }
    if (contractValue.isEmpty || int.parse(contractValue) == 0) {
      toast('${Translations.of(context).enterContractValue}');
    } else {
      String id = ids.join(', ');
      var invoiceObj = {
        "hoursId": id,
        "contractType": selectedType,
        "contractValue": contractValue,
        "taxPercentage": personalTax,
        "dueDate": dueDate.replaceAll(
            ' ${Translations.of(context).days.toLowerCase()}', ""),
        "vat": vat,
        "reference": reference,
        "explanation": explanation,
        "invoiceTotal":
            "${contractValue == "" ? "" : totalContractValue * double.parse(contractValue)}",
      };
      String data = json.encode(invoiceObj);
      if (invoiceDraftList.contains(draftItem)) {
        setState(() {
          invoiceDraftList.remove(draftItem);
          invoiceDraftList.add(data);
        });
      } else {
        setState(() => invoiceDraftList.add(data));
      }
      prefs.setStringList("${uid}invoiceDraftList", invoiceDraftList);
      Navigator.pushReplacementNamed(context, RouteKeys.MANAGE_PAYMENT_SCREEN);
      toast(
          "${Translations.of(context).filesAreNotSavedYet}\n${Translations.of(context).draftSavedSuccessfully}");
    }
  }

  void initializeFields({context, workedhourList, paymentInvoice}) {
    dueDateList = [
      "1 ${Translations.of(context).days.toLowerCase()}",
      "2 ${Translations.of(context).days.toLowerCase()}",
      "3 ${Translations.of(context).days.toLowerCase()}",
      "4 ${Translations.of(context).days.toLowerCase()}",
      "5 ${Translations.of(context).days.toLowerCase()}",
      "6 ${Translations.of(context).days.toLowerCase()}",
      "7 ${Translations.of(context).days.toLowerCase()}",
      "8 ${Translations.of(context).days.toLowerCase()}",
      "9 ${Translations.of(context).days.toLowerCase()}",
      "10 ${Translations.of(context).days.toLowerCase()}",
      "14 ${Translations.of(context).days.toLowerCase()}",
      "21 ${Translations.of(context).days.toLowerCase()}",
      "30 ${Translations.of(context).days.toLowerCase()}",
    ];
    vatList = [
      "0 %",
      "24 %",
      "14 %",
      "0 % ${Translations.of(context).contruction}",
    ];

    dueDate = '1 ${Translations.of(context).days.toLowerCase()}';
    vat = "";

    getPercentage(context);
    getEmployerList(context);
    if (workedhourList != null && workedhourList.isNotEmpty) {
      setState(() {
        dailyWOrkDetailsList = workedhourList;
        workData = workedhourList[0];
        selectedType = workedhourList[0].type;
      });
      dailyWorkDetailsSelected();
      getTotalAmount();
    }
    if (paymentInvoice != null) {
      invoiceDataSelected();
      var draftA = {
        "hoursId": paymentInvoice.seekerId,
        "contractType": paymentInvoice.contractType,
        "contractValue": paymentInvoice.contractValue,
        "taxPercentage": paymentInvoice.tax,
        "dueDate": paymentInvoice.dueDate,
        "vat": paymentInvoice.vat,
        "reference": paymentInvoice.invoiceReference,
        "explanation": paymentInvoice.name,
        "invoiceTotal": paymentInvoice.invoiceTotal,
      };
      setState(() {
        draftArray = json.encode(draftA);
        contractValue = paymentInvoice.contractValue;
        selectedType = paymentInvoice.contractType;
        personalTax = paymentInvoice.tax;
        dueDate = paymentInvoice.dueDate +
            " ${Translations.of(context).days.toLowerCase()}";
        vat = paymentInvoice.vat.length > 4
            ? "0 % ${Translations.of(context).contruction}"
            : paymentInvoice.vat;
        reference = paymentInvoice.invoiceReference;
        explanation = paymentInvoice.name;
        hoursIds = paymentInvoice.seekerId.split(", ");
      });
    }
  }

  void getPercentage(context) async {
    http.Response response = await getPaySlipSummeryApi();
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      print(decoded);
      print(decoded['my_tax']);
      setState(() => personalTax = decoded['my_tax'].toString());
    } else if (response.statusCode == 400) {
      var decoded = jsonDecode(response.body);
      toast(decoded['error']);
    } else if (response.statusCode == 401) {
      NetworkClass.unAuthenticatedUser(context, response);
    } else if (response.statusCode == 503) {
      NetworkClass.internetNotConnection(response);
    }
  }
}
