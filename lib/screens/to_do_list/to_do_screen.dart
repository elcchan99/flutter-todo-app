import 'package:flutter/material.dart';
import 'package:todo_kch_app/models/to_do_item.dart';
import 'package:todo_kch_app/screens/to_do_list/components/focused_item.dart';
import 'package:todo_kch_app/screens/to_do_list/mask_overlay/mask_overlay.dart';

import 'components/header.dart';
import 'components/item.dart';

class ToDoScreen extends StatefulWidget {
  final List<ToDoItemModel> initialList;

  const ToDoScreen({Key key, this.initialList = const []}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class ModelKeyWrapper {
  final ToDoItemModel model;
  final GlobalKey<ToDoItemState> key;
  final GlobalKey<MaskOverlayState> maskKey;

  ModelKeyWrapper(
      {@required this.model, @required this.key, @required this.maskKey});

  factory ModelKeyWrapper.autoKey(ToDoItemModel model) {
    return ModelKeyWrapper(
      model: model,
      key: LabeledGlobalKey<ToDoItemState>(model.id),
      maskKey: GlobalKey(),
    );
  }
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<ModelKeyWrapper> todos;

  int _currentFocus = -1;

  @override
  void initState() {
    todos = widget.initialList.map((e) => ModelKeyWrapper.autoKey(e)).toList();
    super.initState();
  }

  void onChecked(value, index) {
    setState(() {
      todos[index].model.isDone = value;
    });
  }

  void onAddButtonPressed() {
    print("Add button clicked");
    setState(() {
      final newItem = ToDoItemModel.autoId(title: "", tag: "");
      todos.insert(0, ModelKeyWrapper.autoKey(newItem));
      _currentFocus = 0;

      collapseItems(exceptIndex: _currentFocus);
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

  void expandItem(int index) {
    print("expandItem $index");
    setState(() {
      _currentFocus = index;
      collapseItems(exceptIndex: _currentFocus);
      todos[index].key.currentState.expand();
      todos[index].maskKey.currentState.setMask();
    });
  }

  void collapseItem(int index) {
    print("collapseItem $index");
    setState(() {
      _currentFocus = -1;
      todos[index].key.currentState.collapse();
      todos[index].maskKey.currentState.setUnmask();
    });
  }

  void collapseItems({int exceptIndex}) {
    print("collapseItems except $exceptIndex");
    // Reference: https://stackoverflow.com/questions/48930372/flutter-collapsing-expansiontile-after-choosing-an-item
    todos.asMap().entries.forEach((entry) {
      final int index = entry.key;
      final ModelKeyWrapper todo = entry.value;
      if (index != exceptIndex) {
        todo.key.currentState.collapse();
        todos[index].maskKey.currentState.setUnmask();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(children: [
              ToDoHeader(),
              Expanded(
                child: ListView.builder(
                  // key: Key("to-do-list-view"),
                  physics: _currentFocus == -1
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final item = todos[index].model;
                    // print("${item.id}: ${item.title}");
                    final itemKey = todos[index].key;
                    final maskKey = todos[index].maskKey;
                    return Dismissible(
                      key: ObjectKey(item),
                      confirmDismiss: (direction) {
                        return Future.value(_currentFocus != index);
                      },
                      onDismissed: (direction) {
                        onItemDeleted(item, index);
                      },
                      child: MaskOverlay(
                        key: maskKey,
                        masked: _currentFocus == index,
                        onMaskTap: () {
                          collapseItem(index);
                        },
                        child: ToDoItem(
                          key: itemKey,
                          item: item,
                          onChecked: (value) {
                            onItemChecked(item, value);
                          },
                          color: Colors.white,
                          initialExpand: _currentFocus == index,
                          onExpanded: () {
                            expandItem(index);
                          },
                          onCollapsed: () {
                            collapseItem(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
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
}
