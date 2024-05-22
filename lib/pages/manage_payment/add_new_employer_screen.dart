import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/controllers/add_employer_controller.dart';
import 'package:way_to_work/helpers/helper.dart';
import 'package:way_to_work/locale/translation_strings.dart';

class AddNewEmployerScreen extends StatefulWidget {
  final String id;
  AddNewEmployerScreen({this.id});
  @override
  _AddNewEmployerState createState() => _AddNewEmployerState();
}

class _AddNewEmployerState extends StateMVC<AddNewEmployerScreen> {
  AddEmployerDetailsController _con;

  _AddNewEmployerState() : super(AddEmployerDetailsController()) {
    _con = controller;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeLang = false;
      _con.initializeFields(context);
    });
    if (widget.id != null) {
      _con.setEmployerDetails(widget.id, context);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (changeLang == true) {
      _con.initializeFields(context);
    }
    setState(() => changeLang = false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                            "${Translations.of(context).addNewEmployers}",
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
                          horizontal: 5.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          children: [
                            _commonText(
                                "${Translations.of(context).invoiceRecipient} *"),
                            _dropDownField(),
                            _con.dropdownValue ==
                                    "${Translations.of(context).company}"
                                ? _commonText(
                                    "${Translations.of(context).companyName} *")
                                : _commonText(
                                    "${Translations.of(context).nameOfEmployer} *"),
                            _con.dropdownValue ==
                                    "${Translations.of(context).company}"
                                ? _companyNameTextBox()
                                : Container(),
                            _con.dropdownValue ==
                                    "${Translations.of(context).company}"
                                ? Container()
                                : _employeNameTextBox(),
                            _commonText(
                                "${Translations.of(context).employerTelephone} *"),
                            _telephoneTextBox(),
                            _con.dropdownValue ==
                                    "${Translations.of(context).company}"
                                ? _commonText(
                                    "${Translations.of(context).employerYTunnus} *")
                                : _commonText(
                                    "${Translations.of(context).employerSSN} *"),
                            _con.dropdownValue ==
                                    "${Translations.of(context).company}"
                                ? _yTunnusTextBox()
                                : Container(),
                            _con.dropdownValue ==
                                    "${Translations.of(context).company}"
                                ? Container()
                                : _ssnTextBox(),
                            _commonText(
                                "${Translations.of(context).emailOfEmployer} *"),
                            _emailTextBox(),
                            // _commonText(
                            // "${Translations.of(context).employerTaxNo}"),
                            // _taxTextBox(),
                            _commonText(
                                "${Translations.of(context).addressOfEmploye} *"),
                            _addressTextBox(),
                            SizedBox(
                              height: 18.0,
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
    return Container(
      padding:
          EdgeInsets.only(top: 22.0, bottom: 10.0, left: 15.0, right: 10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
      ),
    );
  }

  Widget _ssnTextBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.ssn == null ? '' : _con.ssn,
        onChanged: (val) => setState(() => _con.ssn = val),
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

  Widget _dropDownField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Center(
        child: DropdownButton(
          value: _con.dropdownValue,
          hint: Text("${Translations.of(context).selectAreaOfField}"),
          underline: Container(),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
          ),
          items: _con.dropdownList.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
          onChanged: (value) => setState(() => _con.dropdownValue = value),
        ),
      ),
    );
  }

  Widget _companyNameTextBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.companyName == null ? '' : _con.companyName,
        onChanged: (val) => setState(() => _con.companyName = val),
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

  Widget _employeNameTextBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.employName == null ? '' : _con.employName,
        onChanged: (val) => setState(() => _con.employName = val),
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

  Widget _telephoneTextBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.phone == null ? '' : _con.phone,
        maxLength: 10,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) => setState(() => _con.phone = val),
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          fillColor: Colors.white,
          counterText: "",
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _yTunnusTextBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.yTunnus == null ? '' : _con.yTunnus,
        onChanged: (val) => setState(() => _con.yTunnus = val),
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

  Widget _emailTextBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.email == null ? '' : _con.email,
        onChanged: (val) => setState(() => _con.email = val),
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

  // Widget _taxTextBox() {
  //   return new Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 10.0),
  //     child: new TextFormField(
  //       initialValue: _con.tax == null ? '' : _con.tax,
  //       onChanged: (val) => setState(() => _con.tax = val),
  //       decoration: InputDecoration(
  //         fillColor: Colors.white,
  //         filled: true,
  //         border: OutlineInputBorder(
  //           borderSide: BorderSide.none,
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _addressTextBox() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.address == null ? '' : _con.address,
        onChanged: (val) => setState(() => _con.address = val),
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
          onPressed: () => widget.id != null
              ? _con.editWorkDetailsFunction(context)
              : _con.addEmployeDetailsFunction(context),
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
