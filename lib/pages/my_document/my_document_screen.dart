import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/main.dart';
import 'package:way_to_work/packages/expansion.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/pages/my_document/e_contract_view.dart';
import 'package:way_to_work/controllers/my_document/my_document_controller.dart';

class MyDocumentScreen extends StatefulWidget {
  @override
  _MyDocumentScreenState createState() => _MyDocumentScreenState();
}

class _MyDocumentScreenState extends StateMVC<MyDocumentScreen> {
  MyDocumentController _con;
  AppModel data;
  _MyDocumentScreenState() : super(MyDocumentController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.getDocumentList(context);
    _con.getContractList(context);
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
                        right: _con.size.height * 0.06,
                        bottom: _con.size.height * 0.06,
                        child: Container(
                          // color: Colors.white.withOpacity(0.5),
                          child: GestureDetector(
                            onTap: () => showLangDialog(context, data),
                            child: Container(
                              height: _con.size.height * 0.05,
                              width: _con.size.height * 0.05,
                              color: Colors.transparent,
                            ),
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
                              "${Translations.of(context).myDocument}",
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
                      //       EdgeInsets.only(top: 100, left: 25.0, bottom: 10),
                      //   child: Text(
                      //     "${Translations.of(context).myDocument}",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  _con.requiredParameter.isEmpty
                      ? Container()
                      : Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: _con.size.width * 0.05),
                          child: Text(
                            "${Translations.of(context).warningYouMustAddDocumentLike} ${requiredDoctext()}.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => _con.onMyDocumentTap(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: _con.size.width * 0.9,
                      height: _con.size.height * 0.085,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${Translations.of(context).myDocument}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                              _con.myDocumentExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_right,
                              color: Colors.white),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _con.addMyDocFun(context),
                            child: Container(
                              width: _con.size.height * 0.065,
                              height: _con.size.height * 0.045,
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
                    ),
                  ),
                  ExpandedSection(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: _con.size.width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      child: _con.docList == []
                          ? Container()
                          : Column(
                              children: _con.docList
                                  .asMap()
                                  .map(
                                    (index, value) => MapEntry(
                                      index,
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () => setState(() =>
                                                  value.isExpanded =
                                                      !value.isExpanded),
                                              child: Container(
                                                height: 50,
                                                width: _con.size.width,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        "${_con.transletType(context, value.docType)} : ${value.title}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Icon(value.isExpanded
                                                        ? Icons
                                                            .keyboard_arrow_down
                                                        : Icons
                                                            .arrow_forward_ios),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ExpandedSection(
                                              expand: value.isExpanded,
                                              child: Column(
                                                children: [
                                                  listTileWidget(
                                                    text1:
                                                        "${Translations.of(context).documentType}",
                                                    text2: '${value.docType}',
                                                  ),
                                                  dividerWidget(),
                                                  listTileWidget(
                                                    text1:
                                                        '${Translations.of(context).startDate}',
                                                    text2: '${value.startDate}',
                                                  ),
                                                  dividerWidget(),
                                                  listTileWidget(
                                                    text1:
                                                        '${Translations.of(context).expiryDate}',
                                                    text2:
                                                        '${value.expiryDate}',
                                                  ),
                                                  dividerWidget(),
                                                  status(value),
                                                  _button(
                                                    "${Translations.of(context).view}",
                                                    () => _launchURL(
                                                        id: value.fileName),
                                                  ),
                                                  SizedBox(height: 10),
                                                  value.isDelete
                                                      ? _button(
                                                          "${Translations.of(context).delete}",
                                                          () =>
                                                              _con.deleteMyDoc(
                                                                  value.id,
                                                                  value
                                                                      .fileName,
                                                                  context))
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ),
                    ),
                    expand: _con.myDocumentExpanded,
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => _con.onContractType(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: _con.size.width * 0.9,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${Translations.of(context).contractByFile}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                              _con.contractFileExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_right,
                              color: Colors.white),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _con.addContractFun(context),
                            child: Container(
                              width: _con.size.height * 0.065,
                              height: _con.size.height * 0.045,
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
                    ),
                  ),
                  ExpandedSection(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: _con.size.width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      child: _con.contractList == []
                          ? Container()
                          : Column(
                              children: _con.contractList
                                  .asMap()
                                  .map(
                                    (index, value) => MapEntry(
                                      index,
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () => setState(() =>
                                                  value.isExpanded =
                                                      !value.isExpanded),
                                              child: Container(
                                                height: 50,
                                                width: _con.size.width,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text(
                                                        "${Translations.of(context).myContract}"),
                                                    Spacer(),
                                                    Icon(value.isExpanded
                                                        ? Icons
                                                            .keyboard_arrow_down
                                                        : Icons
                                                            .arrow_forward_ios),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ExpandedSection(
                                              expand: value.isExpanded,
                                              child: Column(
                                                children: [
                                                  listTileWidget(
                                                    text1:
                                                        "${Translations.of(context).expiryDate}",
                                                    text2:
                                                        '${value.expiryDate}',
                                                  ),
                                                  dividerWidget(),
                                                  listTileWidget(
                                                    text1:
                                                        '${Translations.of(context).contractName}',
                                                    text2:
                                                        '${value.contractName}',
                                                  ),
                                                  _button(
                                                    "${Translations.of(context).view}",
                                                    () => _launchContractURL(
                                                        id: value.fileName),
                                                  ),
                                                  _button(
                                                    "${Translations.of(context).delete}",
                                                    () => _con
                                                        .deleteContractValue(
                                                      value.id,
                                                      value.fileName,
                                                      context,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ),
                    ),
                    expand: _con.contractFileExpanded,
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => _con.onEContractTap(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: _con.size.width * 0.9,
                      height: _con.size.height * 0.085,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            "${Translations.of(context).eContract}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Spacer(),
                          Icon(
                              _con.eContractExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  ExpandedSection(
                    expand: _con.eContractExpanded,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      child: _con.eContractList == []
                          ? Container()
                          : Column(
                              children: _con.eContractList
                                  .asMap()
                                  .map(
                                    (index, value) => MapEntry(
                                      index,
                                      InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EContractView(
                                              id: value,
                                            ),
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 50,
                                          width: _con.size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Text(
                                                  "${Translations.of(context).myContract}"),
                                              Spacer(),
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: () =>
                                                    _downloadEContractURL(
                                                        id: value),
                                                child: Container(
                                                  height: 40,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${Translations.of(context).download}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  _launchURL({String id}) async {
    String url = '${_con.myDocUrl}$id';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchContractURL({String id}) async {
    String url = '${_con.contractUrl}$id';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _downloadEContractURL({String id}) async {
    String url = '${_con.eContractUrl}$id';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  Widget status(val) => ListTile(
        leading: Container(
          width: _con.size.width * 0.3,
          child: Text(
            "${Translations.of(context).status}",
            style: TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Container(
          width: _con.size.width * 0.4,
          alignment: Alignment.centerRight,
          child: Text(
            DateTime.now().difference(DateTime.parse(val.startDate)).isNegative
                ? "${Translations.of(context).notInUse}"
                : val.isExpired
                    ? "${Translations.of(context).documentExpired}"
                    : "${Translations.of(context).documentNotExpired}",
            style: TextStyle(
                fontSize: 14,
                color: DateTime.now()
                        .difference(DateTime.parse(val.startDate))
                        .isNegative
                    ? Colors.black
                    : val.isExpired
                        ? Colors.red
                        : Colors.green,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget listTileWidget({String text1, String text2}) => ListTile(
        leading: Container(
          width: _con.size.width * 0.4,
          child: Text(
            text1,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        trailing: Container(
          width: _con.size.width * 0.4,
          alignment: Alignment.centerRight,
          child: Text(
            text2,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget dividerWidget() => Container(
        height: 1.5,
        width: _con.size.width,
        margin: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
      );

  String requiredDoctext() {
    List<String> text = [];
    if (_con.requiredParameter != null && _con.requiredParameter.isNotEmpty) {
      if (_con.requiredParameter.contains("Work Safety Card")) {
        setState(() => text.add(Translations.of(context).workSafetyCard));
      }
      if (_con.requiredParameter.contains("ID Card")) {
        setState(() => text.add(Translations.of(context).idCard));
      }
      if (_con.requiredParameter.contains("Tax Card")) {
        setState(() => text.add(Translations.of(context).taxCard));
      }
      if (_con.requiredParameter.contains("Passport")) {
        setState(() => text.add(Translations.of(context).passport));
      }
      if (_con.requiredParameter.contains("Driving License")) {
        setState(() => text.add(Translations.of(context).drivingLicense));
      }
      if (_con.requiredParameter.contains("Residence Permit")) {
        setState(() => text.add(Translations.of(context).residencePermit));
      }
      if (_con.requiredParameter.contains("My CV")) {
        setState(() => text.add(Translations.of(context).myCV));
      }
      if (_con.requiredParameter.contains("Other Documents")) {
        setState(() => text.add(Translations.of(context).otherDocuments));
      }
      return text.join(", ");
    } else
      return "";
  }
}
