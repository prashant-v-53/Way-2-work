import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/dashboard_models.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/dashboard_repo.dart';

class InsuranceServiceFormScreen extends StatefulWidget {
  final ProfileModel profileData;
  final InsuranceServiceModel insuranceServiceModel;
  InsuranceServiceFormScreen(
      {@required this.profileData, @required this.insuranceServiceModel});
  @override
  _InsuranceServiceFormScreen createState() => _InsuranceServiceFormScreen();
}

class _InsuranceServiceFormScreen extends State<InsuranceServiceFormScreen> {
  Size size;
  bool isLoading = false;
  List<String> professionalList = [];

  String name = "",
      proffesional,
      ssn = "",
      packageName = "",
      address = "",
      email = "",
      phone = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        professionalList = [
          "${Translations.of(context).construction}",
          "${Translations.of(context).cleaningServices}",
          "${Translations.of(context).transportationServices}",
        ];
      });
    });
    setState(() {
      name = widget.profileData.name;
      ssn = widget.profileData.ssn;
      packageName = widget.insuranceServiceModel.package;
      address = "${widget.profileData.city}, ${widget.profileData.country}.";
      email = widget.profileData.email;
      phone = widget.profileData.mobileNo;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      body: isLoading
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
                            "${Translations.of(context).sendEmail}",
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
                                "${Translations.of(context).yourName} *"),
                            nameField(),
                            _commonText(
                                "${Translations.of(context).yourProffesion}"),
                            _selectProfessionType(),
                            _commonText(
                                "${Translations.of(context).lightEntrepreneurSSN} *"),
                            _ssnField(),
                            _commonText(
                                "${Translations.of(context).yelApproximateSumFor2020}"),
                            _yelApproximate2020(),
                            _commonText(
                                "${Translations.of(context).address} *"),
                            _addressField(),
                            _commonText("${Translations.of(context).email} *"),
                            _emailField(),
                            _commonText("${Translations.of(context).phone} *"),
                            _phoneField(),
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

  Widget _addressField() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: address,
        readOnly: true,
        onChanged: (val) => setState(() => address = val),
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

  Widget _ssnField() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        readOnly: true,
        initialValue: ssn,
        onChanged: (val) => setState(() => ssn = val),
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

  Widget _yelApproximate2020() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: packageName,
        onChanged: (val) => setState(() => packageName = val),
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

  Widget nameField() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        readOnly: true,
        initialValue: name == null ? "" : name,
        onChanged: (val) => setState(() => name = val),
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

  Widget _selectProfessionType() {
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
            value: proffesional,
            hint: Text("${Translations.of(context).selectAreaOfField}"),
            underline: Container(),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
            ),
            items: professionalList.map<DropdownMenuItem<String>>((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
            onChanged: (value) => setState(() => proffesional = value),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: email,
        readOnly: true,
        onChanged: (val) => setState(() => email = val),
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

  Widget _phoneField() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: phone,
        readOnly: true,
        onChanged: (val) => setState(() => phone = val),
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
          onPressed: () => sendFun(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  ${Translations.of(context).send}",
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

  void sendFun() async {
    setState(() => isLoading = true);
    try {
      Response response = await sendEmailApi(
          name,
          proffesional,
          widget.profileData.dob,
          ssn,
          packageName,
          address,
          email,
          widget.insuranceServiceModel.id,
          phone);
      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        Navigator.pop(context);
        toast("${Translations.of(context).insuranceRequestSentSuccessfully}");
      } else if (response.statusCode == 401) {
        setState(() => isLoading = false);
        NetworkClass.unAuthenticatedUser(context, response);
      } else if (response.statusCode == 503) {
        NetworkClass.internetNotConnection(response);
        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
        toast("${Translations.of(context).somethingWentToWrong}");
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
}
