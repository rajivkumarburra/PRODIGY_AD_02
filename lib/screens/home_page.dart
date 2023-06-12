import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../func/to_do.dart';
import './add_task.dart';
import './task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = "";

  @override
  void initState() {
    setState(() {
      uid = ToDo.getUid();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('todos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          final documents = snapshot.data!.docs;
          return documents.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/nothing.png',
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'No tasks yet!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Dismissible(
                        key: Key(documents[index]['title']),
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                        ),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            ToDo.toggleDone(
                              documents[index]['isDone'],
                              documents[index]['title'],
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Task complete!',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.black,
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFBDC3C7),
                                  Color(0xFF2C3E50),
                                ],
                                tileMode: TileMode.clamp,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 1.0],
                                transform: GradientRotation(0.5 * 3.14),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  TaskScreen.routeName,
                                  arguments: {
                                    'title': documents[index]['title'],
                                    'description': documents[index]
                                        ['description'],
                                    'date': documents[index]['date'],
                                    'isDone': documents[index]['isDone'],
                                  },
                                );
                              },
                              title: Text(
                                documents[index]['title'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat.yMMMd().format(
                                  documents[index]['date'].toDate(),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              // trailing: Checkbox(
                              //   side: const BorderSide(
                              //     color: Colors.white,
                              //     width: 2.5,
                              //   ),
                              //   checkColor: Colors.black,
                              //   fillColor: MaterialStateProperty.all<Color>(
                              //     Colors.white,
                              //   ),
                              //   shape: const CircleBorder(),
                              //   value: documents[index]['isDone'],
                              //   onChanged: (bool? value) {
                              //     setState(
                              //       () {
                              //         ToDo.toggleDone(
                              //           documents[index]['isDone'],
                              //           documents[index]['title'],
                              //         );
                              //       },
                              //     );
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content: Text(
                              //           'Task complete!',
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //         backgroundColor: Colors.black,
                              //       ),
                              //     );
                              //   },
                              // ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddTask.routeName);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
