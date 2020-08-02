import 'package:flutter/material.dart';
import 'package:todo_kch_app/screens/to_do_list/components/project_text.dart';
import 'package:todo_kch_app/constants.dart' as Constants;

class ItemToolbar extends StatelessWidget {
  final String projectName;
  const ItemToolbar({Key key, this.projectName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ProjectText.header(
        icon: Icons.star,
        iconColor: Constants.STAR_COLOR,
        text: projectName,
        fontSize: 16,
      ),
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: Constants.FONT_GREY),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.format_list_bulleted, color: Constants.FONT_GREY),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.outlined_flag, color: Constants.FONT_GREY),
            onPressed: () {},
          ),
        ],
      )
    ]);
  }
}
