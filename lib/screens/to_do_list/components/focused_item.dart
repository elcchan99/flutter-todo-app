import 'package:flutter/material.dart';
import 'package:todo_kch_app/models/to_do_item.dart';
import 'package:todo_kch_app/constants.dart' as Constants;
import 'package:todo_kch_app/screens/to_do_list/components/project_text.dart';

class ToDoFocusedItem extends StatefulWidget {
  final ToDoItemModel item;
  final Function onChecked;
  final Function onUpdated;
  final Function onBlur;
  final Color color;

  const ToDoFocusedItem(
      {Key key,
      this.item,
      this.onChecked,
      this.color,
      this.onUpdated,
      this.onBlur})
      : super(key: key);

  @override
  _ToDoFocusedItemState createState() => _ToDoFocusedItemState();
}

class _ToDoFocusedItemState extends State<ToDoFocusedItem> {
  GlobalKey get actionKey {
    return widget.key as GlobalKey;
  }

  final titleTextCtrl = TextEditingController();
  final descriptionTextCtrl = TextEditingController();

  OverlayEntry overlayMask;

  @override
  void initState() {
    titleTextCtrl.text = widget.item.title;
    descriptionTextCtrl.text = widget.item.description;
    WidgetsBinding.instance.addPostFrameCallback(drawMask);
    super.initState();
  }

  drawMask(_duration) {
    final RenderBox renderBox = actionKey.currentContext.findRenderObject();
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    if (overlayMask == null) {
      overlayMask = buildMask(context, size, position);
    }
    Overlay.of(context).insert(overlayMask);
  }

  @override
  void dispose() {
    overlayMask.remove();
    super.dispose();
  }

  onExit() {
    widget.onUpdated(
        title: titleTextCtrl.text, description: descriptionTextCtrl.text);
    widget.onBlur();
  }

  OverlayEntry buildMask(context, Size size, Offset position) {
    return OverlayEntry(
      builder: (context) {
        return Stack(children: [
          Positioned(
              top: 0,
              height: position.dy,
              width: size.width,
              child: GestureDetector(
                  onTap: onExit,
                  child: Container(color: Colors.black.withOpacity(0.3)))),
          Positioned(
              top: position.dy + size.height,
              bottom: 0,
              width: size.width,
              child: GestureDetector(
                  onTap: onExit,
                  child: Container(color: Colors.black.withOpacity(0.3)))),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: widget.color, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 0))
        ]),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Checkbox(
            value: widget.item.isDone,
            onChanged: widget.onChecked,
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: TextField(
                            controller: titleTextCtrl,
                            onSubmitted: (text) {
                              onExit();
                            },
                            autofocus: true,
                            style: Theme.of(context).textTheme.headline5,
                            decoration: InputDecoration(
                              focusColor: Colors.pink,
                              hintText: "New To-Do",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          // height: 20,
                          child: TextField(
                            controller: descriptionTextCtrl,
                            onSubmitted: (text) {
                              onExit();
                            },
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              hintText: "Notes",
                              border: InputBorder.none,
                              isDense: true,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProjectText.header(
                                icon: Icons.star,
                                iconColor: Constants.STAR_COLOR,
                                text: "Today",
                                fontSize: 16,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.bookmark_border,
                                        color: Constants.FONT_GREY),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.format_list_bulleted,
                                        color: Constants.FONT_GREY),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.outlined_flag,
                                        color: Constants.FONT_GREY),
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            ])
                      ])))
        ]));
  }
}
