import 'package:flutter/material.dart';
import 'package:todo_kch_app/models/to_do_item.dart';
import 'package:todo_kch_app/screens/to_do_list/components/focused_item.dart';

import 'components/header.dart';
import 'components/item.dart';

class ToDoScreen extends StatefulWidget {
  final List<ToDoItemModel> initialList;

  const ToDoScreen({Key key, this.initialList = const []}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<ToDoItemModel> todos;

  int _currentFocus = -1;

  @override
  void initState() {
    todos = widget.initialList;
    super.initState();
  }

  void onChecked(value, index) {
    setState(() {
      todos[index].isDone = value;
    });
  }

  void onAddButtonPressed() {
    print("Add button clicked");
    setState(() {
      todos.insert(0, ToDoItemModel.autoId(title: "", tag: ""));
      _currentFocus = 0;
    });
  }

  void onItemFocused(ToDoItemModel item, index) {
    print("onItemFocused");
    setState(() {
      _currentFocus = _currentFocus == index ? -1 : index;
    });
  }

  void onItemChecked(ToDoItemModel item, value) {
    print("onItemChecked");
    setState(() {
      item.isDone = value;
    });
  }

  void onItemUpdated(ToDoItemModel item, {String title, String description}) {
    print("onItemUpdated");
    setState(() {
      item.title = title ?? item.title;
      item.description = description ?? item.description;
    });
  }

  void onItemDeleted(ToDoItemModel item, index) {
    print("onItemDeleted");
    setState(() {
      if (_currentFocus == index) {
        _currentFocus = -1;
      }
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              onItemFocused(null, -1);
            },
            child: Container(
              color: Colors.white,
              child: Column(children: [
                ToDoHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final item = todos[index];
                      print("${item.id}: ${item.title}");
                      return GestureDetector(
                            onTap: () {
                              onItemFocused(item, index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 8),
                              child: (_currentFocus == index)
                                  ? buildFocusItem(item,
                                      onUpdated: onItemUpdated, onBlur: () {
                                      onItemFocused(item, -1);
                                    })
                                  : Dismissible(
                                      key: ObjectKey(item),
                                      onDismissed: (direction) {
                                        onItemDeleted(item, index);
                                      },
                                      child: buildItem(item),
                                    )));
                    },
                  ),
                )
              ]),
            ),
          ),
          floatingActionButton: Container(
            decoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: onAddButtonPressed,
              color: Colors.white,
              iconSize: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(ToDoItemModel item) {
    return ToDoItem(
      key: LabeledGlobalKey(item.id),
      item: item,
      onChecked: (value) {
        onItemChecked(item, value);
      },
      color: Colors.white,
    );
  }

  Widget buildFocusItem(ToDoItemModel item,
      {Function onUpdated, Function onBlur}) {
    return ToDoFocusedItem(
      item: item,
      key: LabeledGlobalKey(item.id),
      onChecked: (value) {
        onItemChecked(item, value);
      },
      onUpdated: ({String title, String description}) {
        onUpdated(item, title: title, description: description);
      },
      onBlur: onBlur,
      color: Colors.white,
    );
  }
}
