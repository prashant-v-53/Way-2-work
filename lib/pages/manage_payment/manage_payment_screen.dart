import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:way_to_work/controllers/manage_payement_controller.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/main.dart';
import 'package:way_to_work/models/payment_invoice_model.dart';
import 'package:way_to_work/models/worked_hour_model.dart';
import 'package:way_to_work/pages/manage_payment/daily_work_and_invoice_data.dart';
import 'package:way_to_work/pages/manage_payment/invoice_list_screen.dart';

class ManagePaymentScreen extends StatefulWidget {
  final List<WorkedHourModel> workedHoursList;
  final PaymentInvoice paymentInvoice;

  ManagePaymentScreen({this.workedHoursList, this.paymentInvoice});

  @override
  _ManagePaymentScreenState createState() => _ManagePaymentScreenState();
}

class _ManagePaymentScreenState extends StateMVC<ManagePaymentScreen> {
  ManagePaymentController _con;
  AppModel data;

  _ManagePaymentScreenState() : super(ManagePaymentController()) {
    _con = controller;
  }

  @override
  void initState() {
    if (widget.paymentInvoice != null) {
      setState(() => _con.isAddPart = true);
      _con.getWorkedHoursForDraft(widget.paymentInvoice.seekerId, context);
    } else if (widget.workedHoursList != null) {
      setState(() => _con.isAddPart = true);
      _con.dailyWorkDetailsSelected();
    }
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
                              "${Translations.of(context).invoices}",
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
                      //     "${Translations.of(context).invoices}",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: _con.size.height * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _con.size.width * 0.05,
                          ),
                          child: Text(
                            '${Translations.of(context).anInvoiceWithCompensation}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _con.size.height * 0.04,
                        ),
                        _con.isAddPart == false
                            ? MakePaymentInvoiceScreen(
                                onAddTap: () {
                                  setState(() {
                                    _con.isAddPart = true;
                                    _con.employerDetails = true;
                                    _con.dailyWorkDetails = false;
                                    _con.invoiceData = false;
                                  });
                                },
                              )
                            : Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: _con.size.height * 0.02),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _con.size.width * 0.05,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${Translations.of(context).add}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () => setState(
                                                () => _con.isAddPart = false),
                                            child: Container(
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black),
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DailyWorkAndInvoiceData(
                                      paymentInvoice:
                                          widget.paymentInvoice != null
                                              ? widget.paymentInvoice
                                              : null,
                                      workedhourList:
                                          widget.paymentInvoice != null
                                              ? _con.dailyWOrkDetailsList
                                              : widget.workedHoursList,
                                    ),
                                    SizedBox(height: _con.size.height * 0.02),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  Widget expansionContainer(text1, text2) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      child: Row(
        children: [
          Text(
            text1,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget expansionDivider() => Container(
        height: _con.size.height * 0.005,
        width: _con.size.width * 0.88,
        color: Colors.white,
      );
}
