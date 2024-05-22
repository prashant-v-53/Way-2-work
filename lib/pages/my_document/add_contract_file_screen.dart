import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/controllers/my_document/add_contract_by_file_controller.dart';
import 'package:way_to_work/models/employer_list_model.dart';

class AddContractByFileScreen extends StatefulWidget {
  @override
  _AddContractByFileState createState() => _AddContractByFileState();
}

class _AddContractByFileState extends StateMVC<AddContractByFileScreen> {
  AddContractByFileController _con;

  _AddContractByFileState() : super(AddContractByFileController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.getEmployerList(context);
    super.initState();
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
                            "${Translations.of(context).uploadContract}",
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
                                "${Translations.of(context).selectEmployer}"),
                            _selectContractType(),
                            _commonText("${Translations.of(context).fileName}"),
                            _fileName(),
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

  Widget _fileName() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        onChanged: (val) => setState(() => _con.contractName = val),
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

  Widget _selectContractType() {
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
            hint: Text("${Translations.of(context).selectEmployer}"),
            underline: Container(),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
            ),
            items: _con.employerList
                .map<DropdownMenuItem<EmployerModel>>((EmployerModel val) {
              return DropdownMenuItem<EmployerModel>(
                value: val,
                child: Text(val.companyName),
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
        width: _con.size.width,
        padding: EdgeInsets.symmetric(vertical: 5),
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

  _selectExpiryDate() async {
    final pickDate = await showDatePicker(
      context: context,
      initialDate: _con.expiryDate == ""
          ? _con.currentDate
          : DateFormat("y-M-d").parse(_con.expiryDate),
      firstDate: DateTime(1900),
      lastDate: DateTime(3025),
    );
    if (pickDate != null) {
      setState(() => _con.expiryDate = DateFormat("y-M-d").format(pickDate));
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
