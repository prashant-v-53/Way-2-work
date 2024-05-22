import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:way_to_work/controllers/my_document/e_contract_controller.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/main.dart';

class EContractView extends StatefulWidget {
  final String id;
  EContractView({@required this.id});
  @override
  _EContractViewState createState() => _EContractViewState();
}

class _EContractViewState extends StateMVC<EContractView> {
  EControllerController _con;
  AppModel data;
  _EContractViewState() : super(EControllerController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.getEContractList(widget.id, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _con.size = MediaQuery.of(context).size;
    data = Provider.of<AppModel>(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: _con.isLoading
          ? Center(child: CircularProgressIndicator())
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
                      SafeArea(
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: Colors.red,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 100, left: 25.0),
                        child: Text(
                          "${Translations.of(context).contractOf} :\n${_con.companyName}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).companyName}:",
                    des: _con.companyName,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).createdOn}:",
                    des: _con.createdOn,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).employer}:",
                    des: _con.employer,
                  ),
                  listTileWidget(
                    title: "Y-Tunnus:",
                    des: _con.yTunnus,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).employerEmail}:",
                    des: _con.employerEmail,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).employerPhone}:",
                    des: _con.employerNumber,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title:
                        "${Translations.of(context).lightEntrepreneurEmail}:",
                    des: _con.lightEnterpreneurEmail,
                  ),
                  listTileWidget(
                    title:
                        "${Translations.of(context).lightEntrepreneurPhone}:",
                    des: _con.lightEnterpreneurPhone,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title:
                        "${Translations.of(context).lightEntrepreneurTaxNo}:",
                    des: _con.lightEnterpreneurTaxNumber,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).lightEntrepreneurSSN}:",
                    des: _con.lightEnterpreneurSSN,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title:
                        "${Translations.of(context).lightEntrepreneurBillingAddress}:",
                    des: _con.lightEnterpreneurBillingAddress,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).invoicingEmail}:",
                    des: _con.invoicingEmail,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).worksiteAddress}:",
                    des: _con.workSiteAddress,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).referenceNumber}:",
                    des: _con.refNumber,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).beginningOfWork}:",
                    des: _con.beginningOfWork,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).workFinishedOn}:",
                    des: _con.workFinishedOn,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).billingInterval}:",
                    des: _con.billingInterval,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).otherInformation}:",
                    des: _con.otherInfo,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).invoicingBy}:",
                    des: _con.invoicingBy,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).contractType}:",
                    des: _con.contractType,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).contractValue}:",
                    des: _con.contractValue,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).otherInformation}:",
                    des: _con.otherInfo2,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).foodType}:",
                    des: _con.foodType,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).foodValue}:",
                    des: _con.foodValue,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).travellingType}:",
                    des: _con.travellingType,
                  ),
                  listTileWidget(
                    title: "${Translations.of(context).travellingValue}:",
                    des: _con.travellingValue,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).workDescription}:",
                    des: _con.workDescription,
                  ),
                  dividerWidget(),
                  listTileWidget(
                    title: "${Translations.of(context).termsAndConditions}",
                    des: _con.termsAndcondition,
                  ),
                  dividerWidget(),
                  Container(
                    width: _con.size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Translations.of(context).acceptedByLightEntrepreneur}:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: _con.acceptByLightEnterpreneur == "yes"
                                ? Colors.green
                                : Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              "${_con.acceptByLightEnterpreneur[0].toUpperCase()}${_con.acceptByLightEnterpreneur.substring(1)}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  dividerWidget(),
                  Container(
                    width: _con.size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Translations.of(context).employerSignatute}:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        _con.employerSignatureImage == null
                            ? Container()
                            : Image.memory(_con.employerSignatureImage),
                      ],
                    ),
                  ),
                  Container(
                    width: _con.size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Translations.of(context).lightEntrepreneurSignature}:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        _con.employeeSignatureImage == null
                            ? Container()
                            : Image.memory(
                                _con.employeeSignatureImage,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget listTileWidget({String title, String des}) {
    return Container(
      width: _con.size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Text(
            "$des",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget dividerWidget() {
    return Container(
      width: _con.size.width,
      height: 0.3,
      color: Colors.red,
    );
  }
}
