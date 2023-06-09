import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_page.dart';
import 'screens/add_task.dart';
import 'screens/task.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: "Inter",
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.teal,
        shadowColor: Colors.black,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const AuthScreen();
          }
        },
      ),
      routes: {
        AddTask.routeName: (ctx) => const AddTask(),
        TaskScreen.routeName: (ctx) => const TaskScreen(),
      },
    );
  }
}
