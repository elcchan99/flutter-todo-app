import 'package:flutter/material.dart';
import 'package:todo_kch_app/constants.dart' as Constants;
import 'package:todo_kch_app/screens/to_do_list/components/project_text.dart';

class ToDoHeader extends StatelessWidget {
  const ToDoHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          children: [
            ProjectText.header(
              icon: Icons.star,
              iconColor: Constants.STAR_COLOR,
              text: "Today",
              fontSize: 32,
            )
          ],
        ));
  }
}
