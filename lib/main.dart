import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_kch_app/models/to_do_item.dart';
import 'package:todo_kch_app/screens/to_do_list/to_do_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KCH To Do',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              headline1: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              headline5: TextStyle(fontSize: 16, color: Colors.grey.shade900),
              bodyText1: TextStyle(fontSize: 12, color: Colors.grey.shade400))),
      home: ToDoScreen(
        initialList: [
          ToDoItemModel.autoId(title: "AEM vouncher Stuff"),
          ToDoItemModel.autoId(title: "FWD Group deploy script", tag: "Isobar"),
          ToDoItemModel.autoId(title: "Timesheet"),
          ToDoItemModel.autoId(
              title: "How to impprove performance of a website",
              tag: "Self Improvement"),
        ],
      ),
    );
  }
}
