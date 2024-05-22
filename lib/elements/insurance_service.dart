import 'package:flutter/material.dart';
import 'package:way_to_work/pages/dashboard/send_email_screen.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/models/dashboard_models.dart';
import 'package:way_to_work/packages/expansion.dart';

class InsuranceServiceScreen extends StatefulWidget {
  final List<InsuranceServiceModel> listData;
  final ProfileModel profileData;
  InsuranceServiceScreen({@required this.listData, @required this.profileData});
  @override
  _InsuranceServiceScreenState createState() => _InsuranceServiceScreenState();
}

class _InsuranceServiceScreenState extends State<InsuranceServiceScreen> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Column(
      children: widget.listData
          .asMap()
          .map((index, value) {
            return MapEntry(
              index,
              Column(
                children: [
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () =>
                        setState(() => value.isExpanded = !value.isExpanded),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: size.width * 0.85,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            "${value.insuranceNumber}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          value.isExpanded
                              ? Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 36,
                                )
                              : Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  ExpandedSection(
                    child: expandedContainer(value),
                    expand: value.isExpanded,
                  ),
                  index == widget.listData.length - 1
                      ? SizedBox(height: 10)
                      : Container(),
                ],
              ),
            );
          })
          .values
          .toList(),
    );
  }

  Widget expandedContainer(data) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.01),
          expansionContainer("${Translations.of(context).insuranceName}",
              data.insuranceService),
          expansionDivider(),
          expansionContainer("${Translations.of(context).insuranceNumber}",
              data.insuranceNumber),
          expansionDivider(),
          expansionContainer("${Translations.of(context).insuranceEmail}",
              data.insuranceEmail),
          expansionDivider(),
          expansionContainer(
              "${Translations.of(context).website}", data.website),
          expansionDivider(),
          SizedBox(height: 10),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsuranceServiceFormScreen(
                  insuranceServiceModel: data,
                  profileData: widget.profileData,
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: size.height * 0.05,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  "${Translations.of(context).sendEmail}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
          // expansionDivider(),
          // expansionContainer(
          //     "${Translations.of(context).package}", data.package),
        ],
      ),
    );
  }

  Widget expansionContainer(text1, text2) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.visible,
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
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 0.5,
        // width: size.width * 0.88,
        color: Colors.black12,
      );
}
