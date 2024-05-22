import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/controllers/my_document/add_my_document_controller.dart';

class AddMyDocumentScreen extends StatefulWidget {
  @override
  _AddMyDocumentState createState() => _AddMyDocumentState();
}

class _AddMyDocumentState extends StateMVC<AddMyDocumentScreen> {
  AddMyDocumentController _con;

  _AddMyDocumentState() : super(AddMyDocumentController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _con.documentType = [
          Translations.of(context).workSafetyCard,
          Translations.of(context).taxCard,
          Translations.of(context).idCard,
          Translations.of(context).passport,
          Translations.of(context).drivingLicense,
          Translations.of(context).residencePermit,
          Translations.of(context).mycv,
          Translations.of(context).otherDocuments,
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      body: _con.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            "${Translations.of(context).addMyDocument}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.all(20.0),
                      color: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 20.0),
                        child: Column(
                          children: [
                            _commonText(
                                "${Translations.of(context).documentType}"),
                            _selectDocumentType(),
                            _con.selectedType == Translations.of(context).taxCard
                                ? Column(
                                    children: [
                                      _commonText(
                                          "${Translations.of(context).yearlyIncome}"),
                                      _yearlyIncome(),
                                      _commonText(
                                          "${Translations.of(context).personalTax}"),
                                      _taxPercentage(),
                                      _commonText(
                                          "${Translations.of(context).maxTaxpercentage}"),
                                      _maxTax(),
                                    ],
                                  )
                                : Container(),
                            _commonText(
                                "${Translations.of(context).startDate}"),
                            _startDate(),
                            _commonText(
                                "${Translations.of(context).documentName}"),
                            _docName(),
                            _commonText(
                                "${Translations.of(context).expiryDate}"),
                            _expiryDate(),
                            _commonText(
                                "${Translations.of(context).uploadFile}"),
                            _addfile(),
                            SizedBox(
                              height: 17.0,
                            ),
                            _submitButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
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
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }

  Widget _docName() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        onChanged: (val) => setState(() => _con.documentName = val),
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

  Widget _maxTax() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (val) => setState(() => _con.maxTaxPercentage = val),
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

  Widget _taxPercentage() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (val) => setState(() => _con.personalTax = val),
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

  Widget _yearlyIncome() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        onChanged: (val) => setState(() => _con.yearlyIncome = val),
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

  Widget _selectDocumentType() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        elevation: 0,
        animationDuration: Duration(
          seconds: 1,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: DropdownButton(
            value: _con.selectedType,
            hint: Text("${Translations.of(context).selectAreaOfField}"),
            underline: Container(),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
            ),
            items:
                _con.documentType.map<DropdownMenuItem<String>>((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
            onChanged: (value) => setState(() => _con.selectedType = value),
          ),
        ),
      ),
    );
  }

  Widget _expiryDate() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: _con.size.height * 0.075,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(width: 15),
            Text('${_con.expiryDate == "" ? "yyyy-mm-dd" : _con.expiryDate}'),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.date_range_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                _selectExpiryDate();
              },
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _addfile() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.symmetric(vertical: 5),
        width: _con.size.width,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _con.pickFile(context);
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
                "${_con.file == null ? "${Translations.of(context).noFileChoose}" : "${_con.file.path}"}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startDate() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: _con.size.height * 0.075,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(width: 15),
            Text('${_con.startDate == "" ? "yyyy-mm-dd" : _con.startDate}'),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.date_range_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                _selectStartDate();
              },
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  _selectStartDate() async {
    final pickDate = await showDatePicker(
      context: context,
      initialDate: _con.startDate == ""
          ? _con.currentDate
          : DateFormat("yyyy-MM-dd").parse(_con.startDate),
      firstDate: DateTime(1900),
      lastDate: DateTime(3025),
    );
    if (pickDate != null) {
      setState(
          () => _con.startDate = DateFormat("yyyy-MM-dd").format(pickDate));
    }
  }

  _selectExpiryDate() async {
    final pickDate = await showDatePicker(
      context: context,
      initialDate: _con.expiryDate == ""
          ? _con.currentDate
          : DateFormat("yyyy-MM-dd").parse(_con.expiryDate),
      firstDate: DateTime(1900),
      lastDate: DateTime(3025),
    );
    if (pickDate != null) {
      setState(
          () => _con.expiryDate = DateFormat("yyyy-MM-dd").format(pickDate));
    }
  }

  Widget _submitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ButtonTheme(
        height: 50.0,
        buttonColor: Colors.black,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () => _con.addFunction(context),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
