import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:way_to_work/helpers/helper.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/helpers/app_config.dart';
import 'package:way_to_work/elements/app_loader.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/payment_invoice_model.dart';
import 'package:way_to_work/pages/manage_payment/manage_payment_screen.dart';
import 'package:way_to_work/controllers/make_payment/make_payment_controller.dart';

class MakePaymentInvoiceScreen extends StatefulWidget {
  final Function onAddTap;
  MakePaymentInvoiceScreen({this.onAddTap});
  @override
  _MakePaymentInvoiceScreenState createState() =>
      _MakePaymentInvoiceScreenState();
}

class _MakePaymentInvoiceScreenState
    extends StateMVC<MakePaymentInvoiceScreen> {
  MakePaymentInvoiceController _con;
  _MakePaymentInvoiceScreenState() : super(MakePaymentInvoiceController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.getPaymentList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _con.size.width * 0.05),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: _con.isLoading
                      ? AppLoader()
                      : Material(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                          elevation: 2.0,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 8.0,
                            ),
                            child: DropdownButton(
                              underline: SizedBox(),
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              value: _con.dropdownValue,
                              hint: hintWidget(),
                              items: _con.paymentList
                                  .map<DropdownMenuItem<PaymentInvoice>>(
                                (PaymentInvoice e) {
                                  return DropdownMenuItem<PaymentInvoice>(
                                    child: dropWidget(e),
                                    value: e,
                                  );
                                },
                              ).toList(),
                              onChanged: (value) => _con.onDropChange(value),
                            ),
                          ),
                        ),
                ),
              ),
              InkWell(
                onTap: widget.onAddTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _con.isLoading
              ? SizedBox(height: 20)
              : _con.paymentList.isEmpty
                  ? SizedBox(height: 20)
                  : Column(
                      children: [
                        SizedBox(height: 20),
                        listTileWidget(
                          text1: '${Translations.of(context).creationDate}',
                          text2:
                              '${Helper.convertDate(_con.dropdownValue?.createdAt)}',
                        ),
                        dividerWidget(),
                        listTileWidget(
                          text1: '${Translations.of(context).dueDate}',
                          text2:
                              '${_con.dropdownValue?.dueDate} ${Translations.of(context).days.toLowerCase()}',
                        ),
                        dividerWidget(),
                        listTileWidget(
                          text1: '${Translations.of(context).invoiceId}',
                          text2: '${_con.dropdownValue?.invoiceId}',
                        ),
                        dividerWidget(),
                        listTileWidget(
                          text1: '${Translations.of(context).vat}',
                          text2:
                              '${_con.dropdownValue.vat.length > 4 ? "0 % ${Translations.of(context).contruction}" : "${_con.dropdownValue?.vat}${_con.dropdownValue?.id == 'Draft' ? "" : " %"}"}',
                        ),
                        dividerWidget(),
                        listTileWidget(
                          text1: '${Translations.of(context).invoiceTo}',
                          text2:
                              '${invoiceToText(_con.dropdownValue?.invoiceReference)}',
                        ),
                        dividerWidget(),
                        listTileWidget(
                          text1: '${Translations.of(context).totalAmount}',
                          text2: '${_con.dropdownValue?.invoiceTotal} €',
                        ),
                        dividerWidget(),
                        listTileWidget(
                          text1: '${Translations.of(context).payToAccount}',
                          text2:
                              '${_con.dropdownValue?.payToAcc} ${_con.dropdownValue?.payToAcc == "-" ? "" : "€"}',
                        ),
                        dividerWidget(),
                        status(),
                        dividerWidget(),
                        paidstatus(),
                        SizedBox(height: 10),
                        _con.dropdownValue?.id == 'Draft'
                            ? Container()
                            : visitSite(),
                        SizedBox(height: 10),
                        _con.dropdownValue?.id == "Draft"
                            ? _button('${Translations.of(context).makeInvoice}',
                                () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManagePaymentScreen(
                                      paymentInvoice: _con.dropdownValue,
                                    ),
                                  ),
                                );
                              })
                            : _con.dropdownValue?.status == '1'
                                ? _button(
                                    '${Translations.of(context).duplicate}',
                                    () => _con.onDuplicateFunction(
                                        _con.dropdownValue?.id, context))
                                : Column(
                                    children: [
                                      _button(
                                          '${Translations.of(context).edit}',
                                          () => _launchURL(type: "edit")),
                                      SizedBox(height: 10),
                                      _button(
                                          '${Translations.of(context).delete}',
                                          () => _con.deleteInvoiceItem(
                                              _con.dropdownValue?.id, context)),
                                    ],
                                  ),
                        SizedBox(height: 10),
                        _con.dropdownValue?.id == "Draft"
                            ? ButtonTheme(
                                height: _con.size.height / 18.5,
                                minWidth:
                                    MediaQuery.of(context).size.width / 1.18,
                                child: FlatButton(
                                  onPressed: () => _con.deleteInvoice(
                                      context, _con.dropdownValue),
                                  child: Text(
                                      "${Translations.of(context).delete}"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: Colors.black12,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 30),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _button(String name, Function onTap) {
    return ButtonTheme(
      height: _con.size.height / 18.5,
      minWidth: MediaQuery.of(context).size.width / 1.18,
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: RaisedButton(
        elevation: 2.0,
        onPressed: onTap,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget visitSite() {
    return ButtonTheme(
      height: _con.size.height / 18.5,
      minWidth: MediaQuery.of(context).size.width / 1.18,
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: FlatButton(
        onPressed: () => _launchURL(type: "show"),
        child: Text("${Translations.of(context).view}"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.black12,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  String invoiceToText(str) {
    if (str == null || str == "") {
      return "-";
    } else {
      var splitStr = str.toLowerCase().split(' ');
      print(splitStr.length);
      for (var i = 0; i < splitStr.length; i++) {
        splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
      }
      return splitStr.join(' ');
    }
  }

  _launchURL({String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(PrefsKey.USER_ID);
    String url =
        '${App.apiBaseUrl}payment_redirect?user_id=$userId&invoice_id=${_con.dropdownValue?.id}&type=$type';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget status() => ListTile(
        leading: Text(
          "${Translations.of(context).status}",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        trailing: Text(
          _con.dropdownValue?.status == "0"
              ? "${Translations.of(context).pending}"
              : "${Translations.of(context).approved}",
          style: TextStyle(
              fontSize: 16,
              color:
                  _con.dropdownValue?.status == "0" ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold),
        ),
      );

  Widget paidstatus() => ListTile(
        leading: Container(
          width: _con.size.width * 0.4,
          child: Text(
            "${Translations.of(context).paidStatus}",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        trailing: Container(
          width: _con.size.width * 0.4,
          alignment: Alignment.centerRight,
          child: Text(
            _con.dropdownValue?.paidStatus == "1"
                ? "${Translations.of(context).paid}"
                : "${Translations.of(context).notPaid}",
            style: TextStyle(
                fontSize: 16,
                color: _con.dropdownValue?.paidStatus == "1"
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget listTileWidget({String text1, String text2}) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _con.size.width * 0.05,
            vertical: _con.size.height * 0.02),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text1,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text2,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Widget dividerWidget() => Container(
        height: 1.5,
        width: _con.size.width,
        margin: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.black,
      );

  dropWidget(PaymentInvoice e) => Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                e.id == 'Draft'
                    ? "-"
                    : '${e.invoiceNumber == "0" || e.invoiceNumber == "-" ? "" : e.invoiceNumber}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Container(
            width: _con.size.width * 0.001,
            height: 20,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Text(
              e.id == 'Draft' ? "Draft" : '${e.name}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
        ],
      );

  hintWidget() => Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "00",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Container(
            width: _con.size.width * 0.001,
            height: 20,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Text(
              "${Translations.of(context).noInvoices}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
        ],
      );
}
