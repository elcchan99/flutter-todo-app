import 'package:flutter/material.dart';
import 'package:todo_kch_app/models/to_do_item.dart';

class ToDoItem extends StatelessWidget {
  final ToDoItemModel item;
  final Function onChecked;
  final Color color;

  const ToDoItem({Key key, this.item, this.onChecked, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Checkbox(value: item.isDone, onChanged: onChecked),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.headline5,
                overflow: TextOverflow.ellipsis,
              ),
              Text(item.tag, style: Theme.of(context).textTheme.bodyText1),
            ]),
          ))
        ]));
  }
}
