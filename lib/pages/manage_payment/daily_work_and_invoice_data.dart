import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/helper.dart';
import 'package:way_to_work/elements/expansion_tile.dart';
import 'package:way_to_work/models/worked_hour_model.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/employer_list_model.dart';
import 'package:way_to_work/models/payment_invoice_model.dart';
import 'package:way_to_work/controllers/manage_payement_controller.dart';

class DailyWorkAndInvoiceData extends StatefulWidget {
  final List<WorkedHourModel> workedhourList;
  final PaymentInvoice paymentInvoice;

  DailyWorkAndInvoiceData({this.workedhourList, this.paymentInvoice});

  @override
  _DailyWorkAndInvoiceDataState createState() =>
      _DailyWorkAndInvoiceDataState();
}

class _DailyWorkAndInvoiceDataState extends StateMVC<DailyWorkAndInvoiceData> {
  ManagePaymentController _con;

  _DailyWorkAndInvoiceDataState() : super(ManagePaymentController()) {
    _con = controller;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeLang = false;
      _con.initializeFields(
        context: context,
        workedhourList: widget.workedhourList,
        paymentInvoice: widget.paymentInvoice,
      );
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (changeLang == true) {
      _con.initializeFields(
        context: context,
        workedhourList: widget.workedhourList,
        paymentInvoice: widget.paymentInvoice,
      );
    }
    setState(() => changeLang = false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    return _con.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(height: _con.size.height * 0.02),
              Center(
                child: ExpansionTileWidget(
                  backgroundColor: Colors.black12,
                  color: Colors.grey,
                  expandedWidget: employerDetails(),
                  isExpanded: _con.employerDetails,
                  name: '${Translations.of(context).employerDetails}',
                  onTap: () => _con.employerDetailsSelected(),
                ),
              ),
              SizedBox(height: _con.size.height * 0.02),
              Center(
                child: ExpansionTileWidget(
                  backgroundColor: Colors.black12,
                  color: Colors.grey,
                  expandedWidget: dailyWorkExpandedWidget(),
                  isExpanded: _con.dailyWorkDetails,
                  name: '${Translations.of(context).dailyWorkDetails}',
                  onTap: () => _con.dailyWorkDetailsSelected(),
                ),
              ),
              SizedBox(height: _con.size.height * 0.02),
              Center(
                child: ExpansionTileWidget(
                  backgroundColor: Colors.black12,
                  color: Colors.red,
                  expandedWidget: invoiceData(),
                  isExpanded: _con.invoiceData,
                  name: '${Translations.of(context).invoiceData}',
                  onTap: () {
                    _con.invoiceDataSelected();
                    if (_con.employerList.length == 0) {
                      toast(
                          '${Translations.of(context).addValidEmployerDetails}');
                    } else if (_con.dailyWOrkDetailsList.length == 0) {
                      toast(
                          '${Translations.of(context).addValidDailyWorkDetails}');
                    }
                  },
                ),
              ),
            ],
          );
  }

  Widget dailyWorkExpandedWidget() {
    return Column(
      children: [
        _con.dailyWOrkDetailsList.length == 0
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  _dateSelection(),
                  SizedBox(
                    height: 10.0,
                  ),
                  t("${Translations.of(context).date}", _con.workData.date),
                  _divider(),
                  t(
                      "${Translations.of(context).contractType}",
                      _con.workData.type == "Hours"
                          ? "${Translations.of(context).hours}"
                          : "${Translations.of(context).pieces}"),
                  _divider(),
                  t(
                      _con.workData.type == "Hours"
                          ? "${Translations.of(context).hoursWorked}"
                          : "${Translations.of(context).amount}",
                      "${_con.workData.workingHours}${_con.workData.type == "Hours" ? "" : "€"}"),
                  _divider(),
                  t("${Translations.of(context).distance} (KM)",
                      "${_con.workData.km} ${_con.workData.km == "" ? "" : "km"}"),
                  _divider(),
                  t("${Translations.of(context).foodCompensation}",
                      _con.workData.dailyCompansations + "€"),
                  _divider(),
                  _con.workData.dayCompansations == "0.00"
                      ? Container()
                      : t("${Translations.of(context).fullhalfdaycompensation}",
                          _con.workData.dayCompansations + "€"),
                  _con.workData.dayCompansations == "0.00"
                      ? Container()
                      : _divider(),
                  _con.workData.otherCompensation == ""
                      ? Container()
                      : t("${Translations.of(context).otherCompensations}",
                          _con.workData.otherCompensation),
                  _con.workData.otherCompensation == ""
                      ? Container()
                      : _divider(),
                  _modifySection(),
                  _button(
                    "${Translations.of(context).delete}",
                    () => _con.deleteWorkedHoursFromManagePayment(context),
                  ),
                ],
              ),
        SizedBox(height: 10),
        _button(
          "${Translations.of(context).add}",
          () => _con.addHours(context, true),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget invoiceData() {
    return _con.dailyWorkDetails == null ||
            _con.dailyWOrkDetailsList.length == 0
        ? Container()
        : _con.employerList == null || _con.employerList.length == 0
            ? Container()
            : Column(
                children: [
                  SizedBox(height: 20.0),
                  _selectCompany(),
                  _commonText("${Translations.of(context).contractType} *"),
                  _contractType(),
                  _commonText(_con.selectedType == "Hours"
                      ? "${Translations.of(context).hoursValue} *"
                      : "${Translations.of(context).value} *"),
                  _contractValue(),
                  SizedBox(height: 20),
                  _totalAmount(
                    "${Translations.of(context).totalAmount} \n ${_con.contractValue == "" ? "0" : calculation().toStringAsFixed(2)}€",
                  ),
                  _commonText("${Translations.of(context).vat} *"),
                  _vat(),
                  _con.vat == "" ? SizedBox(height: 5) : Container(),
                  _con.vat == ""
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${Translations.of(context).vat} ${Translations.of(context).notSelected}",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Container(),
                  _commonText("${Translations.of(context).dueDate} *"),
                  _dueDate(),
                  _commonText("${Translations.of(context).personalTax}"),
                  _taxVero(),
                  _commonText(
                      "${Translations.of(context).addAttachmentForReceipt}"),
                  _addReceipt(),
                  _commonText("${Translations.of(context).multipleFiles}"),
                  _multipleFiles(),
                  _commonText("${Translations.of(context).reference}"),
                  _referance(),
                  _commonText("${Translations.of(context).explanation}"),
                  _explanation(),
                  SizedBox(height: 20),
                  _button(
                    '${Translations.of(context).savedAsDraft}',
                    () {
                      if (_con.vat != "") {
                        setState(() {
                          _con.totalContractValue = 0;
                          _con.hoursIds = [];
                        });
                        _con.dailyWOrkDetailsList.forEach((element) {
                          setState(() => _con.hoursIds.add(element.id));
                          if (element.workingHours.isNotEmpty) {
                            setState(() => _con.totalContractValue +=
                                int.parse(element.workingHours));
                          }
                        });
                        _con.saveAsDraftFun(
                            _con.hoursIds, context, _con.draftArray);
                      }
                    },
                  ),
                  _saveSendButton(),
                ],
              );
  }

  Widget _dateSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2.0,
        animationDuration: Duration(
          seconds: 1,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: DropdownButton(
            value: _con.workData,
            underline: SizedBox(),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            items: _con.dailyWOrkDetailsList
                .map<DropdownMenuItem<WorkedHourModel>>(
              (WorkedHourModel e) {
                return DropdownMenuItem<WorkedHourModel>(
                  child: Text(e.date),
                  value: e,
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                _con.workData = value;
              });
            },
          ),
        ),
      ),
    );
  }

// Date Selection End

// Common Divider Start
  Widget _divider() {
    return Divider(
      color: Colors.white,
      indent: 10.0,
      endIndent: 10.0,
      thickness: 1.5,
    );
  }

  Widget _modifySection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonTheme(
            height: _con.size.height * 0.06,
            minWidth: MediaQuery.of(context).size.width / 2.5,
            child: FlatButton(
              onPressed: () async {
                DateTime date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1946),
                  lastDate: DateTime(3025),
                );
                _con.onDuplicateWorkedHoursFun(DateFormat('y-M-d').format(date),
                    _con.workData.id, context);
              },
              child: Text("${Translations.of(context).duplicate}"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
            ),
          ),
          ButtonTheme(
            height: _con.size.height * 0.06,
            minWidth: MediaQuery.of(context).size.width / 2.5,
            child: FlatButton(
              onPressed: () => _con.editHours(context, _con.workData),
              child: Text("${Translations.of(context).modify}"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String name, Function onTap) {
    return ButtonTheme(
      height: _con.size.height / 18.5,
      minWidth: MediaQuery.of(context).size.width / 1.18,
      buttonColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: RaisedButton(
        elevation: 2.0,
        onPressed: onTap,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _commonText(String title) {
    return Padding(
      padding:
          EdgeInsets.only(top: 22.0, bottom: 10.0, left: 15.0, right: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }

  Widget _selectCompany() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: DropdownButton(
            underline: Container(),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            items: _con.employerList.map<DropdownMenuItem<EmployerModel>>(
              (EmployerModel e) {
                return DropdownMenuItem<EmployerModel>(
                  child: Text(e.companyName),
                  value: e,
                );
              },
            ).toList(),
            onChanged: (EmployerModel employee) {
              setState(() => _con.currentEmployer = employee);
              _con.getEmployerDetails(employee.id, context);
            },
            value: _con.currentEmployer,
          ),
        ),
      ),
    );
  }

  Widget _contractType() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        elevation: 2.0,
        animationDuration: Duration(
          seconds: 1,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: IgnorePointer(
            ignoring: true,
            child: DropdownButton(
              underline: SizedBox(),
              value:
                  "${_con.selectedType[0].toUpperCase()}${_con.selectedType.substring(1)}",
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
              items: _con.typesList.map<DropdownMenuItem<String>>((String e) {
                return DropdownMenuItem<String>(
                  child: Text(e == "Hours"
                      ? "${Translations.of(context).hours}"
                      : "${Translations.of(context).pieces}"),
                  value: e,
                );
              }).toList(),
              onChanged: (value) => setState(() => _con.selectedType = value),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contractValue() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.contractValue,
        onChanged: (val) => setState(() {
          _con.contractValue = val;
        }),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _totalAmount(String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0),
          height: _con.size.height * 0.005,
          width: _con.size.width * 0.08,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.red,
          ),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0),
            height: _con.size.height * 0.005,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _taxVero() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: _con.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          '${_con.personalTax}',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _dueDate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        elevation: 2.0,
        animationDuration: Duration(
          seconds: 1,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: DropdownButton(
            underline: SizedBox(),
            value: _con.dueDate,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            items: _con.dueDateList.map<DropdownMenuItem<String>>((String e) {
              return DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              );
            }).toList(),
            onChanged: (value) => setState(() => _con.dueDate = value),
          ),
        ),
      ),
    );
  }

  Widget _vat() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        elevation: 2.0,
        animationDuration: Duration(
          seconds: 1,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: DropdownButton(
            underline: SizedBox(),
            value: _con.vat == '' ? null : _con.vat,
            hint: Text(
                '${Translations.of(context).select} ${Translations.of(context).vat}'),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            items: _con.vatList.map<DropdownMenuItem<String>>((String e) {
              return DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              );
            }).toList(),
            onChanged: (value) => setState(() => _con.vat = value),
          ),
        ),
      ),
    );
  }

  Widget _addReceipt() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.symmetric(vertical: 5),
        width: _con.size.width,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _con.pickReceiptFile(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "${Translations.of(context).chooseFile}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${_con.receiptFile == null ? "${Translations.of(context).noFileChoose}" : "${_con.receiptFile.path}"}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Multiple File Start
  Widget _multipleFiles() {
    Size size = MediaQuery.of(context).size;
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.symmetric(vertical: 5),
        width: size.width,
        child: Row(
          children: [
            InkWell(
              onTap: () => _con.pickMultipleFiles(context),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "${Translations.of(context).chooseFile}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${_con.multipleFileList == null || _con.multipleFileList.length == 0 ? "${Translations.of(context).noFileChoose}" : "${_con.multipleFileList.length} Items"}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Referance Start
  Widget _referance() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.reference,
        onChanged: (val) => setState(() => _con.reference = val),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

// Referance End

// Explanation Start
  Widget _explanation() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.explanation,
        onChanged: (val) => setState(() => _con.explanation = val),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

// Explanation End

// Save & Send Button Start
  Widget _saveSendButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: ButtonTheme(
        height: 50.0,
        buttonColor: Colors.black,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            if (_con.personalTax == "60") {
              toast("${Translations.of(context).pleaseAddOrUpdateYourTaxCard}");
            } else if (_con.vat != "") {
              setState(() {
                _con.totalContractValue = 0;
                _con.hoursIds = [];
              });
              _con.dailyWOrkDetailsList.forEach((element) {
                setState(() => _con.hoursIds.add(element.id));
                if (element.workingHours.isNotEmpty) {
                  setState(() => _con.totalContractValue +=
                      double.parse(element.workingHours));
                }
              });
              _con.addInvoiceFun(_con.hoursIds, context, _con.draftArray);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  ${Translations.of(context).submit}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.done,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget employerDetails() {
    _con.size = MediaQuery.of(context).size;
    return Column(
      children: [
        _con.employerList.length == 0 || _con.employerList == null
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: _con.size.height * 0.025,
                  ),
                  _sc(),
                  SizedBox(
                    height: _con.size.height * 0.025,
                  ),
                  _con.name == null ||
                          _con.name.isEmpty && _con.nameCompany == null ||
                          _con.nameCompany.isEmpty
                      ? Container()
                      : t("${Translations.of(context).name}",
                          _con.name.isEmpty ? _con.nameCompany : _con.name),
                  _con.name == null ||
                          _con.name.isEmpty && _con.nameCompany == null ||
                          _con.nameCompany.isEmpty
                      ? Container()
                      : _divider(),
                  _con.telephone == null || _con.telephone == ""
                      ? Container()
                      : t("${Translations.of(context).telephone}",
                          _con.telephone),
                  _con.telephone == null || _con.telephone == ""
                      ? Container()
                      : _divider(),
                  _con.email == null || _con.email == ""
                      ? Container()
                      : t("${Translations.of(context).email}", _con.email),
                  _con.email == null || _con.email == ""
                      ? Container()
                      : _divider(),
                  _con.yTunnus == null || _con.yTunnus == ""
                      ? Container()
                      : t("${Translations.of(context).employerYTunnus}",
                          _con.yTunnus),
                  _con.yTunnus == null || _con.yTunnus == ""
                      ? Container()
                      : _divider(),
                  _con.ssn == null || _con.ssn == ""
                      ? Container()
                      : t("${Translations.of(context).ssn}", _con.ssn),
                  _con.ssn == null || _con.ssn == "" ? Container() : _divider(),
                  // t("${Translations.of(context).taxNumber}",
                  // _con.taxNo == null ? "" : _con.taxNo),
                  // _divider(),
                  _con.address == null || _con.address == ""
                      ? Container()
                      : t("${Translations.of(context).address}", _con.address),
                  _con.address == null || _con.address == ""
                      ? Container()
                      : _divider(),
                  // t("${Translations.of(context).type}",
                  //     _con.type == null ? "" : _con.type),
                  SizedBox(
                    height: 35.0,
                  ),
                  _ds(),
                  _con.currentEmployer.companyType == "root"
                      ? Container()
                      : _b(
                          "${Translations.of(context).modify}",
                          () => _con.editEmployeFunction(
                            context,
                            _con.currentEmployer.id,
                          ),
                        ),
                ],
              ),
        SizedBox(height: 10),
        _b(
          "${Translations.of(context).addNew}",
          () => _con.addEmployeFunction(context),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget t(String first, String second) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _con.size.width * 0.05,
          vertical: _con.size.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Text(
              first,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              second,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sc() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: DropdownButton(
            underline: Container(),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            items: _con.employerList.map<DropdownMenuItem<EmployerModel>>(
              (EmployerModel e) {
                return DropdownMenuItem<EmployerModel>(
                  child: Text(e.companyName),
                  value: e,
                );
              },
            ).toList(),
            onChanged: (EmployerModel employee) {
              setState(() => _con.currentEmployer = employee);
              _con.getEmployerDetails(employee.id, context);
            },
            value: _con.currentEmployer,
          ),
        ),
      ),
    );
  }

  Widget _ds() {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ButtonTheme(
          //   height: size.height * 0.06,
          //   minWidth: size.height * 0.06,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //   ),
          //   buttonColor: Colors.red,
          //   child: RaisedButton(
          //     onPressed: () {},
          //     child: Icon(
          //       Icons.arrow_back_ios,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          ButtonTheme(
            height: _con.size.height / 18.5,
            minWidth: MediaQuery.of(context).size.width / 1.2,
            child: FlatButton(
              onPressed: () =>
                  _con.deleteEmployerDetails(_con.currentEmployer.id, context),
              child: Text("${Translations.of(context).delete}"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
            ),
          ),
          // ButtonTheme(
          //   height: size.height * 0.06,
          //   minWidth: size.height * 0.06,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //   ),
          //   buttonColor: Colors.red,
          //   child: RaisedButton(
          //     onPressed: () {},
          //     child: Icon(
          //       Icons.arrow_forward_ios,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _b(String name, Function onTap) {
    return ButtonTheme(
      height: _con.size.height / 18.5,
      minWidth: MediaQuery.of(context).size.width / 1.18,
      buttonColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: RaisedButton(
        elevation: 2.0,
        onPressed: onTap,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  double calculation() {
    double val = _con.totalContractValue * double.parse(_con.contractValue);
    return val;
  }
}
