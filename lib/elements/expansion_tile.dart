import 'package:flutter/material.dart';
import 'package:way_to_work/packages/expansion.dart';

class ExpansionTileWidget extends StatefulWidget {
  final String name;
  final Color color;
  final Function onTap;
  final bool isExpanded;
  final Color backgroundColor;
  final Widget expandedWidget;
  ExpansionTileWidget({
    this.name,
    this.color,
    this.onTap,
    this.isExpanded,
    this.backgroundColor,
    this.expandedWidget,
  });

  @override
  _ExpansionTileWidgetState createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.1,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color:
                widget.isExpanded ? widget.backgroundColor : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: size.height * 0.1,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    size: size.width * 0.08,
                    color: Colors.white,
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ),
        ExpandedSection(
          expand: widget.isExpanded,
          child: Center(
            child: AnimatedContainer(
              width: size.width * 0.9,
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: widget.expandedWidget,
            ),
          ),
        ),
      ],
    );
  }
}
