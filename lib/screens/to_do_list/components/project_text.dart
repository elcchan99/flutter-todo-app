import 'package:flutter/material.dart';

class ProjectText extends StatelessWidget {
  final Icon icon;
  final Text text;

  const ProjectText({Key key, this.icon, this.text}) : super(key: key);

  factory ProjectText.header(
      {Key key, IconData icon, Color iconColor, String text, double fontSize}) {
    return ProjectText(
      icon: Icon(icon, color: iconColor, size: fontSize),
      text: Text(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [icon, SizedBox(width: 5), text]);
  }
}
