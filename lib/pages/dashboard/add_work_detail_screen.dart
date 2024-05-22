import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/models/add_compensation_models.dart';
import 'package:way_to_work/models/worked_hour_model.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/controllers/add_work_details_controller.dart';

class AddWorkDetailScreen extends StatefulWidget {
  final WorkedHourModel data;
  final bool fromManagePayment;
  final bool firstTime;
  final String type;
  AddWorkDetailScreen(
      {this.data,
      @required this.fromManagePayment,
      @required this.firstTime,
      @required this.type});

  @override
  _AddWorkDetailsState createState() => _AddWorkDetailsState();
}

class _AddWorkDetailsState extends StateMVC<AddWorkDetailScreen> {
  AddWorkDetailsController _con;
  _AddWorkDetailsState() : super(AddWorkDetailsController()) {
    _con = controller;
  }

  @override
  void initState() {
    setState(() {
      _con.contactType = widget.type;
    });
    _con.getDayCompensation(
        widget.data == null ? null : widget.data.dayCompansations,
        widget.data?.date,
        context);
    _con.getLunchCompensation(
        widget.data == null ? null : widget.data.dailyCompansations,
        widget.data?.date,
        context);
    if (widget.data != null) {
      _con.setWorkDetails(widget.data);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      body: new SafeArea(
        child: _con.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            "${Translations.of(context).workDetails}",
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
                    new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.all(20.0),
                      color: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 20.0),
                        child: new Column(
                          children: [
                            _commonText(
                                "${Translations.of(context).contractType} *"),
                            _contractType(),
                            _commonText("${Translations.of(context).date} *"),
                            _datePicker(),
                            _commonText(
                                "${Translations.of(context).tripStart}"),
                            _tripStart(),
                            _commonText("${Translations.of(context).tripEnds}"),
                            _tripEnds(),
                            _commonText("${Translations.of(context).tripTime}"),
                            _tripTime(),
                            _commonText(
                                "${Translations.of(context).tripAddresses}"),
                            _tripAddress(),
                            _commonText(
                                "${Translations.of(context).distanceTravelled} (km)"),
                            _km(),
                            _commonText(_con.contactType == 'Hours'
                                ? "${Translations.of(context).numberOfHoursWorked} *"
                                : "${Translations.of(context).numberOfPieces} *"),
                            _noWorkedHours(),
                            _commonText(
                                "${Translations.of(context).lunchCompensation}"),
                            _lunchCompensation(),
                            _commonText(
                                "${Translations.of(context).fullhalfdaycompensation}"),
                            _fullhalfDayCompensation(),
                            _commonText(
                                "${Translations.of(context).otherCompensations}"),
                            _otherCompensations(),
                            _commonText(
                                "${Translations.of(context).workDescription}"),
                            _workDescription(),
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

// Common Text Start
  Widget _commonText(String title) {
    return Padding(
      padding:
          EdgeInsets.only(top: 22.0, bottom: 10.0, left: 15.0, right: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
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
        elevation: 0,
        animationDuration: Duration(
          seconds: 1,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: IgnorePointer(
            ignoring:
                widget.firstTime == true ? false : widget.fromManagePayment,
            child: DropdownButton(
              value:
                  "${_con.contactType[0].toUpperCase()}${_con.contactType.substring(1)}",
              underline: Container(),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              items:
                  _con.contractList.map<DropdownMenuItem<String>>((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val == "Hours"
                      ? "${Translations.of(context).hours}"
                      : "${Translations.of(context).pieces}"),
                );
              }).toList(),
              onChanged: (value) => setState(() => _con.contactType = value),
            ),
          ),
        ),
      ),
    );
  }

  _selectDate() async {
    final pickDate = await showDatePicker(
      context: context,
      initialDate: _con.date == ""
          ? _con.currentDate
          : DateFormat("yyyy-MM-dd").parse(_con.date),
      firstDate: DateTime(1900),
      lastDate: DateTime(3025),
    );
    if (pickDate != null) {
      setState(() => _con.date = DateFormat("yyyy-MM-dd").format(pickDate));
    }
  }

  Widget _datePicker() {
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
            Text('${_con.date == "" ? "yyyy-mm-dd" : _con.date}'),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.date_range_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                _selectDate();
              },
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  _tripStartTime(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locale = prefs.getString('locale');
    final _time = await showTimePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      initialTime: _con.tripStart == ""
          ? TimeOfDay.fromDateTime(
              DateFormat.jm("en")
                  .parse("${DateFormat("hh:mm").format(DateTime.now())} AM"),
            )
          : TimeOfDay.fromDateTime(
              DateFormat.jm("en").parse(_con.tripStart),
            ),
    );

    if (_time != null) {
      if (locale == "en") {
        setState(() => _con.tripStart = _time.format(context));
      } else {
        final now = new DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
        setState(() => _con.tripStart =
            "${DateFormat('hh:mm').format(dt)} ${_time.hour >= 12 ? "PM" : "AM"}");
      }
    }
    if (_time != null && _con.tripEnd.isNotEmpty) {
      DateTime date = DateFormat.jm("en").parse(_con.tripEnd);
      DateTime date2 = DateFormat.jm("en").parse(_con.tripStart);
      var format = DateFormat("HH:mm");
      var one = format.parse(DateFormat("HH:mm").format(date));
      var two = format.parse(DateFormat("HH:mm").format(date2));
      setState(() => _con.tripTimeText.text =
          one.difference(two).toString().split(":00.")[0]);
    }
  }

  _tripEndsTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locale = prefs.getString('locale');
    final _time = await showTimePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      initialTime: _con.tripEnd == ""
          ? TimeOfDay.fromDateTime(
              DateFormat.jm("en")
                  .parse("${DateFormat("hh:mm").format(DateTime.now())} PM"),
            )
          : TimeOfDay.fromDateTime(
              DateFormat.jm("en").parse(_con.tripEnd),
            ),
    );
    if (_time != null) {
      if (locale == "en") {
        setState(() => _con.tripEnd = _time.format(context));
      } else {
        final now = new DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
        setState(() => _con.tripEnd =
            "${DateFormat('hh:mm').format(dt)} ${_time.hour >= 12 ? "PM" : "AM"}");
      }
    }
    if (_time != null && _con.tripStart.isNotEmpty) {
      DateTime date = DateFormat.jm("en").parse(_con.tripEnd);
      DateTime date2 = DateFormat.jm("en").parse(_con.tripStart);
      var format = DateFormat("HH:mm");
      var one = format.parse(DateFormat("HH:mm").format(date));
      var two = format.parse(DateFormat("HH:mm").format(date2));
      setState(() => _con.tripTimeText.text =
          one.difference(two).toString().split(":00.")[0]);
    }
  }

  Widget _tripStart() {
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
            Text('${_con.tripStart == "" ? "--:-- --" : _con.tripStart}'),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.timer,
                color: Colors.black,
              ),
              onPressed: () {
                _tripStartTime(context);
              },
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _tripEnds() {
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
            Text('${_con.tripEnd == "" ? "--:-- --" : _con.tripEnd}'),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.timer,
                color: Colors.black,
              ),
              onPressed: () {
                _tripEndsTime();
              },
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _tripAddress() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.tripAddresses,
        onChanged: (val) => setState(() => _con.tripAddresses = val),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "${Translations.of(context).enterTripAddresses}",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _km() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.km,
        onChanged: (val) => setState(() => _con.km = val),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "${Translations.of(context).enterKM}",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _lunchCompensation() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            underline: SizedBox(),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            value: _con.lunch,
            items: _con.lunchCompensationList
                .map<DropdownMenuItem<LunchCompensation>>(
              (LunchCompensation e) {
                return DropdownMenuItem<LunchCompensation>(
                  child: Text('${e.value}'),
                  value: e,
                );
              },
            ).toList(),
            onChanged: (value) {
              _con.onLunchDropChange(value);
              setState(() {
                _con.fullHalfDayCompensation =
                    _con.fullHalfDayCompensationList[0];
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _fullhalfDayCompensation() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
          child: IgnorePointer(
            ignoring: 0 == double.parse("${_con.lunch.value}") ? false : true,
            child: DropdownButton(
              underline: SizedBox(),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
              value: _con.fullHalfDayCompensation,
              hint: Text(""),
              items: _con.fullHalfDayCompensationList
                  .map<DropdownMenuItem<FullHalfDayCompensation>>(
                (FullHalfDayCompensation e) {
                  return DropdownMenuItem<FullHalfDayCompensation>(
                    child: Text('${e.value}'),
                    value: e,
                  );
                },
              ).toList(),
              onChanged: (value) => _con.onDayDropChange(value),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tripTime() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        readOnly: true,
        controller: _con.tripTimeText,
        onChanged: (val) => setState(() => _con.tripTimeText.text = val),
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

  Widget _noWorkedHours() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.workedHours,
        onChanged: (val) => setState(() => _con.workedHours = val),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: _con.contactType == 'Hours'
              ? '${Translations.of(context).enterHoursWorked}'
              : '${Translations.of(context).enterPieces}',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _otherCompensations() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.otherCompensation,
        onChanged: (val) => setState(() => _con.otherCompensation = val),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "${Translations.of(context).otherCompensations}",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _workDescription() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        initialValue: _con.workDescription,
        onChanged: (val) => setState(() => _con.workDescription = val),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "${Translations.of(context).workDescription}",
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
        height: _con.size.height * 0.07,
        buttonColor: Colors.black,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            _con.validateInput(context).then((isSuccess) {
              widget.data != null
                  ? _con.editWorkDetailsFunction(
                      context, widget.fromManagePayment)
                  : _con.addWorkDetailsFunction(
                      context, widget.fromManagePayment);
            });
          },
          child: Row(
            children: [
              Text(
                "${Translations.of(context).submit}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Spacer(),
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
