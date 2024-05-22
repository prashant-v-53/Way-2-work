import 'package:flutter/material.dart';

class Commanbtn extends StatefulWidget {
  final Function ontap;
  final String name;
  final Color color;
  Commanbtn({this.ontap, this.name, this.color});

  @override
  _CommanbtnState createState() => _CommanbtnState();
}

class _CommanbtnState extends State<Commanbtn> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return MaterialButton(
      disabledColor: Colors.grey,
      height: size.height * 0.08,
      // colorBrightness: Brightness.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      onPressed: widget.ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ],
      ),
      color: widget.color,
    );
  }
}
