import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String icon, title, description;
  final Function onPressed;

  BigButton(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.description,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal,
      elevation: 4.0,
      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        constraints: BoxConstraints(maxHeight: 115.0),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    icon,
                    style: TextStyle(fontSize: 36.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: VerticalDivider(width: 0, color: Colors.white70),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(onTap: onPressed),
          ],
        ),
      ),
    );
  }
}
