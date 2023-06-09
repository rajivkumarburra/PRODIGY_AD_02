import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String title;
  String description;
  DateTime? date;
  bool isDone;

  ToDo(
    this.title,
    this.description,
    this.date,
    this.isDone,
  );

  static toggleDone(bool? isDone, String title) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String uid = user!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todos')
        .doc(title)
        .delete();
  }

  static void addTask(String title, String description, DateTime? date) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String uid = user!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todos')
        .doc(title)
        .set({
      'title': title,
      'description': description,
      'date': date,
      'isDone': false,
    });
  }

  static List<ToDo> todos = [
    ToDo(
      "Buy Milk",
      "Buy 2 litres of milk",
      DateFormat.yMMMMd('en_US').parse("October 10, 2021"),
      false,
    ),
    ToDo(
      "Buy Eggs",
      "Buy 1 dozen of eggs",
      DateFormat.yMMMMd('en_US').parse("October 10, 2021"),
      false,
    ),
    ToDo(
      "Buy Bread",
      "Buy 1 loaf of bread",
      DateFormat.yMMMMd('en_US').parse("October 10, 2021"),
      false,
    ),
  ];

  static String getUid() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String uid = user!.uid;
    return uid;
  }
}
