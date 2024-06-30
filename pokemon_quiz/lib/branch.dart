import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'Pokemondata.dart';

class branch extends StatefulWidget {
  const branch({Key? key}) : super(key: key);

  @override
  State<branch> createState() => _branch();
}

class _branch extends State<branch> {
  //List<String> numberList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  List<Quiz_data> quiz_data = [];
  int _counter = 10;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initState2();

    _viewfirebase();
  }

  void _viewfirebase() async {
    final db = FirebaseFirestore.instance;

    final event = await db
        .collection('Quizdata')
        .orderBy('quiz_id', descending: false)
        .get();
    //final event = await db.collection("Quizdata").get();
    final docs = event.docs;
    final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();

    setState(() {
      this.quiz_data = pokemon;
      print(quiz_data.length);
    });
  }

  @override
  void initState2() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_counter > 0) {
            _counter--;
          } else {
            stopTimer();
            // Navigator.pop(context);
            print('タイマー終了！');
          }
        });
      },
    );
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4択クイズ'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Level1",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(width: 1100),
                Text(
                  _counter.toString(),
                  style: TextStyle(fontSize: 50, color: Colors.amber),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
