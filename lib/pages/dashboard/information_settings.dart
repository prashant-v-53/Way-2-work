import 'package:flutter/material.dart';

class InformationSettings extends StatefulWidget {
  final String name;
  final Function ontap;
  InformationSettings({this.name, this.ontap});
  @override
  _InformationSettingsState createState() => _InformationSettingsState();
}

class _InformationSettingsState extends State<InformationSettings> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: MaterialButton(
        color: Colors.white,
        height: 50,
        padding: EdgeInsets.all(10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: widget.ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
