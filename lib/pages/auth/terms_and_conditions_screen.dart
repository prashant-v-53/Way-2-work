import 'package:flutter/material.dart';
import 'package:way_to_work/helpers/app_colors.dart';
import 'package:way_to_work/locale/translation_strings.dart';

class TermsAndConditionScreen extends StatefulWidget {
  @override
  _TermsAndConditionScreenState createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      bottomNavigationBar: Container(
        height: size.height * 0.05,
        alignment: Alignment.centerRight,
        margin: EdgeInsets.all(10),
        child: RaisedButton(
          color: AppColors.appRedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${Translations.of(context).agree}",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Icon(Icons.keyboard_arrow_right, color: Colors.white),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * 0.24,
                  child: Row(
                    children: [
                      Spacer(),
                      Image(
                        width: size.height * 0.25,
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/manage.png"),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height * 0.12,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100, left: 25.0),
                  child: Text(
                    "${Translations.of(context).termsAndConditions}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: size.height * 0.03,
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Text(
                """${Translations.of(context).tACPoint1}""",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
