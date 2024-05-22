import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/main.dart';
import 'package:provider/provider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:way_to_work/packages/expansion.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/controllers/worked_hours_controller.dart';

class WorkedHoursScreen extends StatefulWidget {
  @override
  _WorkedHoursState createState() => _WorkedHoursState();
}

class _WorkedHoursState extends StateMVC<WorkedHoursScreen> {
  WorkedHoursController _con;
  AppModel data;
  _WorkedHoursState() : super(WorkedHoursController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.getWorkedHours(context);
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
                              "${Translations.of(context).workbook}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding:
                      //       EdgeInsets.only(top: 90, left: 25.0, bottom: 10),
                      //   child: Text(
                      //     "${Translations.of(context).workbook}",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                    width: _con.size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: _con.size.height * 0.1,
                          width: _con.size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: _con.size.width * 0.03),
                              Expanded(
                                child: Text(
                                  "${Translations.of(context).addDetails}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                height: _con.size.height * 0.07,
                                width: _con.size.height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _con.addHours(context),
                                  ),
                                ),
                              ),
                              SizedBox(width: _con.size.width * 0.03),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: _con.workedHoursList
                              .asMap()
                              .map((index, value) {
                                return MapEntry(
                                  index,
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () => setState(() => value
                                            .isExpanded = !value.isExpanded),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: _con.size.width * 0.85,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: _con.hoursList.contains(
                                                            value.id) ||
                                                        _con.piecesList
                                                            .contains(value.id)
                                                    ? Icon(
                                                        Icons
                                                            .radio_button_checked,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(Icons
                                                        .radio_button_unchecked),
                                                onPressed: () {
                                                  _con.selectItems(value.type,
                                                      value.id, context);
                                                },
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  "${value.date} - ${value.type == "Hours" || value.type == "hours" ? "${Translations.of(context).hours}" : "${Translations.of(context).pieces}"}",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              value.isExpanded
                                                  ? Icon(
                                                      Icons.keyboard_arrow_down,
                                                      size: 36,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_forward_ios),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ExpandedSection(
                                        expand: value.isExpanded,
                                        child: AnimatedContainer(
                                          width: _con.size.width,
                                          duration: Duration(seconds: 2),
                                          child: Column(
                                            children: [
                                              _title(
                                                  "${Translations.of(context).date}",
                                                  value.date),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).createdOn}",
                                                  value.fullDate),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).contractType}",
                                                  '${value.type == "Hours" || value.type == "hours" ? "${Translations.of(context).hours}" : "${Translations.of(context).pieces}"}'),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).tripStart}",
                                                  value.tripStart),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).tripEnds}",
                                                  value.tripEnd),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).tripAddresses}",
                                                  value.tripAddress),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).distanceTravelled} (km)",
                                                  "${value.km} km"),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).tripTime}",
                                                  value.tripTime),
                                              _divider(),
                                              _title(
                                                  value.type == "Hours" ||
                                                          value.type == "hours"
                                                      ? "${Translations.of(context).workedHours}"
                                                      : "${Translations.of(context).piecesValue}",
                                                  value.workingHours +
                                                      "${value.type == "Hours" || value.type == "hours" ? " h" : " pcs"}"),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).dailyCompensation}",
                                                  value.dailyCompansations +
                                                      "€"),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).fullhalfdaycompensation}",
                                                  value.dayCompansations + "€"),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).otherCompensations}",
                                                  value.otherCompensation +
                                                      "€"),
                                              _divider(),
                                              _title(
                                                  "${Translations.of(context).description}",
                                                  value.extraInformation),
                                              _divider(),
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ButtonTheme(
                                                    height:
                                                        _con.size.height * 0.06,
                                                    minWidth:
                                                        _con.size.width * 0.3,
                                                    child: FlatButton(
                                                      onPressed: () =>
                                                          _con.editHours(
                                                              context, value),
                                                      child: Text(
                                                        "${Translations.of(context).edit}",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                  ButtonTheme(
                                                    height:
                                                        _con.size.height * 0.06,
                                                    minWidth:
                                                        _con.size.width * 0.3,
                                                    child: FlatButton(
                                                      onPressed: () async {
                                                        DateTime date =
                                                            await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(1946),
                                                          lastDate:
                                                              DateTime(3025),
                                                        );
                                                        _con.onDuplicateFun(
                                                            DateFormat('y-M-d')
                                                                .format(date),
                                                            value.id,
                                                            context);
                                                      },
                                                      child: Text(
                                                        "${Translations.of(context).duplicate}",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                              .values
                              .toList(),
                        ),
                        SizedBox(height: 20),
                        _button("${Translations.of(context).delete}",
                            () => _con.deleteWorkedHours(context)),
                        SizedBox(height: 10),
                        _button("${Translations.of(context).useInInvoice}",
                            () => _con.useInInvoiveFun(context, false)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
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

  Widget _title(String first, String second) {
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

  Widget _divider() {
    return Divider(
      color: Colors.white,
      indent: 10.0,
      endIndent: 10.0,
      thickness: 1.5,
    );
  }
}
