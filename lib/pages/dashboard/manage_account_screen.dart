import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:way_to_work/main.dart';
import 'package:provider/provider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/models/month_list_model.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/controllers/manage_account_controller.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends StateMVC<ManageAccountScreen> {
  ManageAccountController _con;
  AppModel data;
  _ManageAccountState() : super(ManageAccountController()) {
    _con = controller;
  }
  @override
  void initState() {
    _con.getAccountDetails(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    data = Provider.of<AppModel>(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: _con.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: _con.size.height * 0.24,
                        child: Row(
                          children: [
                            Spacer(),
                            Image(
                              width: _con.size.height * 0.25,
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  "assets/images/${data.appLocal.languageCode}.png"),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: _con.size.height * 0.05,
                        bottom: _con.size.height * 0.06,
                        child: GestureDetector(
                          onTap: () => showLangDialog(context, data),
                          child: Container(
                            height: _con.size.height * 0.05,
                            width: _con.size.height * 0.05,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: _con.size.height * 0.06,
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: Colors.red,
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              "${Translations.of(context).account}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 90, left: 25.0),
                      //   child: Text(
                      //     "${Translations.of(context).account}",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  Container(
                    width: _con.size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _title("${Translations.of(context).updateProfile}"),
                        _commonTitle("${Translations.of(context).firstName}"),
                        _fullNameWidget(),
                        _commonTitle("${Translations.of(context).lastName}"),
                        _lastNameWidget(),
                        _commonTitle("${Translations.of(context).gender}"),
                        SizedBox(height: 10),
                        _genderDropDown(),
                        SizedBox(height: 20),
                        _commonTitle("${Translations.of(context).dateOfBirth}"),
                        SizedBox(height: 10),
                        _dobDropDown(),
                        SizedBox(height: 20),
                        _commonTitle(
                            "${Translations.of(context).currentAddress}"),
                        _currentAddressWidget(),
                        _commonTitle("${Translations.of(context).residence}"),
                        _residence(),
                        _commonTitle("${Translations.of(context).nationality}"),
                        SizedBox(height: 10),
                        _nationality(),
                        SizedBox(height: 10),
                        _commonTitle("${Translations.of(context).mobilePhone}"),
                        _mobileNoWidget(),
                        // _commonTitle("${Translations.of(context).homePhone}"),
                        // _homeNoWidget(),
                        _commonTitle("${Translations.of(context).personalTax}"),
                        _personalTaxWidget(),
                        _commonTitle(
                            "${Translations.of(context).maxTaxpercentage}"),
                        _maxTaxWidget(),
                        _commonTitle(
                            "${Translations.of(context).yearlyIncome}(€)"),
                        _yearlyIncomeWidget(),
                        // _commonTitle(
                        //     "${Translations.of(context).bruttoSalary}"),
                        // _bruttoSalaryWidget(),
                        // _commonTitle("${Translations.of(context).bulkAmount}"),
                        // _bulkAmountWidget(),
                        // _commonTitle("${Translations.of(context).earnedSoFar}"),
                        // _earnedSoFarWidget(),
                        _title(
                            "${Translations.of(context).bankAccInformation}"),
                        _commonTitle("${Translations.of(context).bankName}"),
                        _bankNameWidget(),
                        _commonTitle(
                            "${Translations.of(context).accountNumber}"),
                        _accNoWidget(),
                        // _commonTitle("${Translations.of(context).bicNumber}"),
                        // _bicNoWidget(),
                        _updateButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _commonTitle(String name) {
    return new Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 35.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _title(String name) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _fullNameWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        initialValue: _con.firstName,
        onChanged: (val) => setState(() => _con.firstName = val),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '${Translations.of(context).enterFirstName}',
        ),
      ),
    );
  }

  Widget _lastNameWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        initialValue: _con.lastName,
        onChanged: (val) => setState(() => _con.lastName = val),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '${Translations.of(context).enterLastName}',
        ),
      ),
    );
  }

  Widget _currentAddressWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        initialValue: _con.currentAddress,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (val) => setState(() => _con.currentAddress = val),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '${Translations.of(context).enterCurrentAddres}',
        ),
      ),
    );
  }

  Widget _mobileNoWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        initialValue: _con.mobileNo,
        maxLength: 10,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) => setState(() => _con.mobileNo = val),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintText: '${Translations.of(context).enterMobileNo}',
        ),
      ),
    );
  }

  // Widget _homeNoWidget() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 30.0,
  //       vertical: 10,
  //     ),
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           blurRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: TextFormField(
  //       initialValue: _con.phoneNo,
  //       onChanged: (val) => setState(() => _con.phoneNo = val),
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: '${Translations.of(context).enterHomePhone}',
  //       ),
  //     ),
  //   );
  // }

  Widget _personalTaxWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        initialValue: _con.personalTax,
        onChanged: (val) => setState(() => _con.personalTax = val),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '',
        ),
      ),
    );
  }

  Widget _maxTaxWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        initialValue: _con.maxTaxPercenatge,
        onChanged: (val) => setState(() => _con.maxTaxPercenatge = val),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '',
        ),
      ),
    );
  }

  Widget _yearlyIncomeWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        initialValue: _con.yearlyIncome,
        onChanged: (val) => setState(() => _con.yearlyIncome = val),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '',
        ),
      ),
    );
  }

  // Widget _bruttoSalaryWidget() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 30.0,
  //       vertical: 10,
  //     ),
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           blurRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: TextFormField(
  //       readOnly: true,
  //       initialValue: _con.bruttoSalary,
  //       onChanged: (val) => setState(() => _con.bruttoSalary = val),
  //       keyboardType: TextInputType.number,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: '',
  //       ),
  //     ),
  //   );
  // }

  // Widget _bulkAmountWidget() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 30.0,
  //       vertical: 10,
  //     ),
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           blurRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: TextFormField(
  //       readOnly: true,
  //       initialValue: _con.bulkAmount,
  //       onChanged: (val) => setState(() => _con.bulkAmount = val),
  //       keyboardType: TextInputType.number,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: '',
  //       ),
  //     ),
  //   );
  // }

  // Widget _earnedSoFarWidget() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 30.0,
  //       vertical: 10,
  //     ),
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           blurRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: TextFormField(
  //       initialValue: _con.earnedSoFar,
  //       onChanged: (val) => setState(() => _con.earnedSoFar = val),
  //       keyboardType: TextInputType.number,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: '0',
  //       ),
  //     ),
  //   );
  // }

  Widget _genderDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: DropdownButton(
        value: _con.gender,
        underline: SizedBox(),
        hint: Text('${Translations.of(context).selectGender}'),
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
        ),
        items: _con.genderList.map((val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(val == 'Male'
                ? '${Translations.of(context).male}'
                : '${Translations.of(context).female}'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _con.gender = value);
        },
      ),
    );
  }

  Widget _nationality() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: DropdownButton(
        value: _con.nationality,
        underline: SizedBox(),
        hint: Text('${Translations.of(context).selectNationality}'),
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
        ),
        items: _con.nationalityList.map((val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _con.nationality = value);
        },
      ),
    );
  }

  Widget _updateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: ButtonTheme(
        height: 50.0,
        buttonColor: Colors.black,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            if (_con.validateInput(context) == true) {
              _con.updateAccountInfo(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  ${Translations.of(context).update}",
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

  Widget _dobDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: new Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: DropdownButton(
                isExpanded: true,
                value: _con.dobDate,
                underline: SizedBox(),
                hint: Text(
                  '${Translations.of(context).day}',
                  style: TextStyle(fontSize: 14),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                ),
                items:
                    List<int>.generate(31, (int index) => index + 1).map((val) {
                  return DropdownMenuItem<int>(
                    value: val,
                    child: Text(val.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _con.dobDate = value);
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: DropdownButton(
                isExpanded: true,
                value: _con.dobMonth,
                underline: SizedBox(),
                hint: Text(
                  '${Translations.of(context).month}',
                  style: TextStyle(fontSize: 13),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                ),
                items: _con.dobMonthList.map((val) {
                  return DropdownMenuItem<MonthModel>(
                    value: val,
                    child: Text(val.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _con.dobMonth = value);
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: DropdownButton(
                value: _con.dobYear,
                isExpanded: true,
                underline: SizedBox(),
                hint: Text(
                  '${Translations.of(context).year}',
                  style: TextStyle(fontSize: 14),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                ),
                items: List<int>.generate(110, (int index) => index + 1901)
                    .map((val) {
                  return DropdownMenuItem<int>(
                    value: val,
                    child: Text(val.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _con.dobYear = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _residence() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: DropdownButton(
                value: _con.country,
                underline: SizedBox(),
                hint: Text('${Translations.of(context).selectCountry}'),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                ),
                items: _con.countryList.map((val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _con.country = value);
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Container(
                height: 50.0,
                child: TextFormField(
                  initialValue: _con.city,
                  onChanged: (val) => setState(() => _con.city = val),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '${Translations.of(context).city}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankNameWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        initialValue: _con.bankName == "null" ? "" : _con.bankName,
        onChanged: (val) => setState(() => _con.bankName = val),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '${Translations.of(context).bankName}',
        ),
      ),
    );
  }

  Widget _accNoWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        initialValue: _con.accountNumber == "null" ? "" : _con.accountNumber,
        onChanged: (val) => setState(() => _con.accountNumber = val),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '${Translations.of(context).accountNumber}',
        ),
      ),
    );
  }

  // Widget _bicNoWidget() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 30.0,
  //       vertical: 10,
  //     ),
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           blurRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: TextFormField(
  //       initialValue: _con.bic == "null" ? "" : _con.bic,
  //       onChanged: (val) => setState(() => _con.bic = val),
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: '${Translations.of(context).bicNumber}',
  //       ),
  //     ),
  //   );
  // }
}
