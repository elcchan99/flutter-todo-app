import 'package:uuid/uuid.dart';

class ToDoItemModel {
  final String id;
  bool isDone;
  String title;
  String description;
  String tag;

  ToDoItemModel({
    this.id,
    this.title,
    this.description = "",
    this.tag = "",
    this.isDone = false,
  });

  factory ToDoItemModel.autoId({
    String id,
    String title,
    String description = "",
    String tag = "",
    bool isDone = false,
  }) {
    return ToDoItemModel(
      id: id ?? Uuid().v4(),
      title: title,
      description: description,
      tag: tag,
      isDone: isDone,
    );
  }
}
