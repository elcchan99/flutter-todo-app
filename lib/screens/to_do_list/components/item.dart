import 'package:flutter/material.dart';
import 'package:todo_kch_app/models/to_do_item.dart';
import 'package:todo_kch_app/screens/to_do_list/components/expandable.dart';

import 'item_toolbar.dart';

class ToDoItem extends StatefulWidget {
  final ToDoItemModel item;
  final Function onChecked;
  final bool initialExpand;
  final Function onExpanded;
  final Function onCollapsed;
  final Color color;

  const ToDoItem(
      {Key key,
      this.item,
      this.onChecked,
      this.initialExpand,
      this.onExpanded,
      this.onCollapsed,
      this.color})
      : super(key: key);

  @override
  ToDoItemState createState() => ToDoItemState();
}

class ToDoItemState extends State<ToDoItem>
    with SingleTickerProviderStateMixin {
  bool isExpand = false;
  final titleTextCtrl = TextEditingController();
  final descriptionTextCtrl = TextEditingController();

  @override
  void initState() {
    print("ToDoItemState initState: $widget");
    isExpand = widget.initialExpand;
    titleTextCtrl.text = widget.item.title;
    descriptionTextCtrl.text = widget.item.description;
    super.initState();
  }

  void collapse() {
    setState(() {
      isExpand = false;
    });
  }

  void expand() {
    setState(() {
      isExpand = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isExpand) {
          widget.onCollapsed();
        } else {
          widget.onExpanded();
        }
      },
      child: Container(
          color: widget.color,
          child: Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Checkbox(
                    value: widget.item.isDone, onChanged: widget.onChecked),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitleTextField(context),
                            AnimatedCrossFade(
                              duration: Duration(milliseconds: 500),
                              crossFadeState: isExpand
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: Text(widget.item.tag,
                                  style: Theme.of(context).textTheme.bodyText1),
                              secondChild: buildDescriptionTextField(context),
                            ),
                          ]),
                      ExpandedSection(
                          expand: isExpand,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                ItemToolbar(projectName: "Today"),
                              ]))
                    ],
                  ),
                ))
              ]),
            ],
          )),
    );
  }

  Widget buildTextField(context,
      {@required TextEditingController controller,
      @required String hintText,
      TextStyle style,
      bool enabled = true,
      bool autofocus = false,
      EdgeInsets contentPadding = EdgeInsets.zero}) {
    return IntrinsicWidth(
      child: Padding(
        padding: contentPadding,
        child: TextField(
            enabled: enabled,
            controller: controller,
            onSubmitted: (text) {
              widget.onCollapsed();
            },
            style: style,
            decoration: InputDecoration.collapsed(
              hintText: hintText,
            )),
      ),
    );
  }

  Widget buildTitleTextField(context) {
    return buildTextField(
      context,
      controller: titleTextCtrl,
      hintText: "New To-Do",
      enabled: isExpand,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildDescriptionTextField(context) {
    return buildTextField(
      context,
      controller: descriptionTextCtrl,
      hintText: "Notes",
      enabled: isExpand,
      style: Theme.of(context).textTheme.bodyText1,
      contentPadding: EdgeInsets.symmetric(vertical: 10),
    );
  }
}
