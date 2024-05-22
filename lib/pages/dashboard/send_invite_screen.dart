import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:way_to_work/helpers/global.dart';
import 'package:way_to_work/helpers/helper.dart';
import 'package:way_to_work/locale/translation_strings.dart';
import 'package:way_to_work/packages/internet_connection.dart';
import 'package:way_to_work/repository/dashboard_repo.dart';

class SendInviteScreen extends StatefulWidget {
  final String url;
  SendInviteScreen({@required this.url});
  @override
  _SendInviteScreen createState() => _SendInviteScreen();
}

class _SendInviteScreen extends State<SendInviteScreen> {
  Size size;
  bool isLoading = false;
  List<String> professionalList = [];

  String name = "", email = "";

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            "${Translations.of(context).sendInvitation}",
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
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.all(20.0),
                      color: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 20.0),
                        child: Column(
                          children: [
                            _commonText(
                                "${Translations.of(context).fullName} *"),
                            nameField(),
                            _commonText("${Translations.of(context).email} *"),
                            _emailField(),
                            _commonText("${Translations.of(context).link}"),
                            _linkField(),
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

  Widget _commonText(String title) {
    return Padding(
      padding:
          EdgeInsets.only(top: 22.0, bottom: 10.0, left: 15.0, right: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        onChanged: (val) => setState(() => name = val),
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

  Widget _emailField() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new TextFormField(
        onChanged: (val) => setState(() => email = val),
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

  Widget _linkField() {
    return new Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: TextFormField(
        initialValue: widget.url,
        readOnly: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
              icon: Icon(
                Icons.copy,
                color: Colors.black,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.url));
                toast("${Translations.of(context).linkCopySuccessfully}");
              }),
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
        height: 50.0,
        buttonColor: Colors.black,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () => sendFun(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  ${Translations.of(context).send}",
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

  void sendFun() async {
    if (name == null || name.isEmpty) {
      toast("${Translations.of(context).enterValidFullName}");
    } else if (email == null || email.isEmpty) {
      toast("${Translations.of(context).enterValidEmail}");
    } else if (Helper.isEmail(email) == false) {
      toast("${Translations.of(context).enterValidEmail}");
    } else {
      setState(() => isLoading = true);
      try {
        Response response = await sendInviteApi(name, email);
        if (response.statusCode == 200) {
          setState(() => isLoading = false);
          Navigator.pop(context, true);
          toast("${Translations.of(context).invitationLinkSentSuccessfully}");
        } else if (response.statusCode == 401) {
          setState(() => isLoading = false);
          NetworkClass.unAuthenticatedUser(context, response);
        } else if (response.statusCode == 503) {
          NetworkClass.internetNotConnection(response);
          setState(() => isLoading = false);
        } else {
          setState(() => isLoading = false);
          toast("${Translations.of(context).somethingWentToWrong}");
        }
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }
}
