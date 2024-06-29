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
  AnimationController? _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_counter > 0) {
            _counter--;
            _controller.value -= 0.1;
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
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4択クイズ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Level1",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(width: 50),
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: AnimatedDecoratedText(
                    animation: _controller,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _counter.toString(),
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
