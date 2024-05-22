import 'package:flutter/material.dart';

class DashboardButton extends StatefulWidget {
  final Function ontap;
  final String name;
  final String image;
  DashboardButton({this.ontap, this.name, this.image});
  @override
  _DashboardButtonState createState() => _DashboardButtonState();
}

class _DashboardButtonState extends State<DashboardButton> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        bottom: size.height * 0.015,
        left: size.width * 0.07,
        right: size.width * 0.07,
      ),
      child: MaterialButton(
        elevation: 2.0,
        highlightElevation: 10.0,
        colorBrightness: Brightness.light,
        height: size.height * 0.07,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        onPressed: widget.ontap,
        child: Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.01,
          ),
          child: Row(
            children: [
              Image.asset(
                widget.image,
                height: size.height * 0.035,
              ),
              SizedBox(
                width: size.width * 0.04,
              ),
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 21,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
