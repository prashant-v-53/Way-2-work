import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/variable_keys.dart';
import 'package:way_to_work/main.dart';
import 'package:way_to_work/packages/switch.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/elements/app_loader.dart';
import 'package:way_to_work/elements/expansion_tile.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/elements/insurance_service.dart';
import 'package:way_to_work/pages/dashboard/receive_document_screen.dart';
import 'package:way_to_work/controllers/dashboard/dashboard_controller.dart';
import 'package:way_to_work/pages/dashboard/send_invite_screen.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends StateMVC<DashBoardScreen> {
  AppModel data;
  DashboardController _con;

  _DashBoardState() : super(DashboardController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.getPaySlipSummeryDetails(context);
    _con.getDashboard(context);
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
              child: AppLoader(),
            )
          : Stack(
              children: [
                SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(top: _con.size.height * 0.18),
                    height: _con.size.width,
                    width: _con.size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/images/d.png',
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: _con.size.height * 0.24,
                            width: _con.size.width,
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
                                  "${Translations.of(context).dashboard}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: _con.size.width * 0.06,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: _con.size.height * 0.02,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(
                                    _con.size.width * 0.1),
                                onTap: () {
                                  _con.pickProfileFile(context);
                                },
                                child: CircleAvatar(
                                  maxRadius: _con.size.width * 0.14,
                                  backgroundImage: _con.profileImage == null
                                      ? NetworkImage(
                                          "${_con.profileUrl}",
                                        )
                                      : FileImage(
                                          _con.profileImage,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: _con.size.width * 0.04,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: _con.size.height * 0.02,
                                ),
                                Text(
                                  _con.profileModel.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: _con.size.width * 0.06,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: _con.size.height * 0.02,
                                ),
                                Text(
                                  _con.profileModel.mobileNo,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: _con.size.width * 0.045,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: _con.size.width * 0.01,
                                ),
                                Text(
                                  _con.profileModel.email,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: _con.size.width * 0.045,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: _con.size.width * 0.01,
                                ),
                                _con.profileModel.city == "" &&
                                        _con.profileModel.country == ""
                                    ? Container()
                                    : Text(
                                        '${_con.profileModel.city}${_con.profileModel.city == "" ? "" : ","} ${_con.profileModel.country}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.045,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                _con.profileModel.city == "" &&
                                        _con.profileModel.country == ""
                                    ? Container()
                                    : SizedBox(
                                        height: _con.size.width * 0.03,
                                      ),
                                Text(
                                  '${Translations.of(context).ssn} : ${_con.profileModel.ssn}',
                                  style: TextStyle(
                                    fontSize: _con.size.width * 0.045,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: _con.size.width * 0.02,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${Translations.of(context).notification}',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: _con.size.height * 0.025,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    CustomSwitch(
                                      value: true,
                                      onChanged: (val) {},
                                      activeColor: Colors.red,
                                      activeTextColor: Colors.white,
                                      inactiveTextColor: Colors.white,
                                      activeText: "ON",
                                      inactiveColor: Colors.grey,
                                      inactiveText: "OFF",
                                    ),
                                    SizedBox(width: _con.size.width * 0.06),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _con.incomePercentage == null
                          ? Container()
                          : Center(
                              child: Container(
                                width: _con.size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _con.size.width * 0.05,
                                        vertical: _con.size.height * 0.01,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${Translations.of(context).incomeLevel} (${_con.incomePercentage} %)",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: _con.size.width * 0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 40,
                                        width: _con.incomePercentage == 0
                                            ? 0
                                            : (_con.incomePercentage / 100) *
                                                _con.size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                      Stack(
                        children: [
                          Container(
                            height: _con.size.width * 0.82,
                            width: _con.size.width * 0.82,
                            padding: EdgeInsets.only(
                                top: 16, right: 14, left: 14, bottom: 5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/puzzel2.png',
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: _con.size.width * 0.25,
                                      child: Text(
                                        _con.numberOfWorkedHours,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: _con.size.width * 0.3,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        _con.invoiceCount,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: _con.size.width * 0.01),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: _con.size.width * 0.2,
                                      child: Text(
                                        '${Translations.of(context).numberOfHoursWorked}',
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: _con.size.width * 0.3,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${Translations.of(context).invoices}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: _con.size.width * 0.25),
                                Row(
                                  children: [
                                    Container(
                                      width: _con.size.width * 0.25,
                                      child: Text(
                                        _con.inviteCount,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: _con.size.width * 0.3,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '*',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: _con.size.width * 0.2,
                                      child: Text(
                                        '${Translations.of(context).invite}',
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: _con.size.width * 0.3,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${Translations.of(context).myCV}\n${Translations.of(context).workPermit}\n${Translations.of(context).workContract}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: _con.size.width * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: _con.size.width * 0.82,
                            width: _con.size.width * 0.82,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context,
                                              RouteKeys.WORKED_HOURS_SCREEN),
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context,
                                              RouteKeys.MANAGE_PAYMENT_SCREEN),
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => sendInvite(_con.sendInviteUrl),
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context,
                                              RouteKeys.MY_DOCUMENT_SCREEN),
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: _con.size.width * 0.14,
                            left: _con.size.width * 0.3,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, RouteKeys.MANAGE_PAYMENT_SCREEN),
                              child: Container(
                                height: _con.size.width * 0.12,
                                width: _con.size.width * 0.12,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Positioned(
                            left: _con.size.width * 0.14,
                            bottom: _con.size.width * 0.3,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, RouteKeys.WORKED_HOURS_SCREEN),
                              child: Container(
                                height: _con.size.width * 0.12,
                                width: _con.size.width * 0.12,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: _con.size.width * 0.14,
                            right: _con.size.width * 0.3,
                            child: GestureDetector(
                              onTap: () => sendInvite(_con.sendInviteUrl),
                              child: Container(
                                height: _con.size.width * 0.12,
                                width: _con.size.width * 0.12,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Positioned(
                            right: _con.size.width * 0.14,
                            top: _con.size.width * 0.3,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, RouteKeys.MY_DOCUMENT_SCREEN),
                              child: Container(
                                height: _con.size.width * 0.12,
                                width: _con.size.width * 0.12,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ExpansionTileWidget(
                        backgroundColor: Colors.black12,
                        color: Colors.grey,
                        expandedWidget: InsuranceServiceScreen(
                          listData: _con.insuranceServiceList,
                          profileData: _con.profileModel,
                        ),
                        isExpanded: _con.isInsuranceExpanded,
                        name: '${Translations.of(context).insuranceService}',
                        onTap: () => _con.insuranceExpanded(),
                      ),
                      SizedBox(height: 20),
                      ExpansionTileWidget(
                        backgroundColor: Colors.black12,
                        color: Colors.red,
                        expandedWidget: ReceiveDocumentScreen(
                          listData: _con.receiveDocumentList,
                          url: _con.receiveDocUrl,
                        ),
                        isExpanded: _con.isGeneralInfoExpanded,
                        name: '${Translations.of(context).receiveDocument}',
                        onTap: () => _con.generalInfoExpanded(),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget t(String first, String second) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _con.size.width * 0.05,
          vertical: _con.size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            first,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            second,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void sendInvite(url) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendInviteScreen(
          url: url,
        ),
      ),
    );
    if (res == true) {
      setState(() {
        _con.insuranceServiceList = [];
        _con.receiveDocumentList = [];
      });
      _con.getPaySlipSummeryDetails(context);
      _con.getDashboard(context);
    }
  }
}
