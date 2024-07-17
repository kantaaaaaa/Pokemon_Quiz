import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemon_quiz/quizcount.dart';
import 'dart:async';

import 'Pokemondata.dart';
import 'Quizpage_popup.dart';

class Resultpage extends StatefulWidget {
  final List<String> resultList;
  final List<String> searchList;

  const Resultpage(
      {Key? key, required this.resultList, required this.searchList})
      : super(key: key);

  @override
  _Resultpage createState() => _Resultpage();
}

class _Resultpage extends State<Resultpage> {
  List<Quiz_data> quiz_data = [];

  // void input_quiz() async {
  //   for (var element in widget.searchList) {
  //     final db = FirebaseFirestore.instance;
  //     final event = await db
  //         .collection('Quizdata')
  //         .where('quiz_id', isEqualTo: element)
  //         .get();
  //     final docs = event.docs;
  //     final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();
  //     this.quiz_data += pokemon;
  //     //print(quiz_data);
  //   }
  // }

  // いっそのことこの関数の中で全部やっちゃおう
  // void firedata() async {
  //   final quizdata_count = await addfirebase_method();
  //   int? value = quizdata_count;
  //   search_arr = generateRandomList(value!);
  //   input_quiz();

  //   await Future.delayed(const Duration(seconds: 3), () {
  //     setState(() {
  //       load = "true";
  //       _counter += 3;
  //     });
  //   });
  //   now_quiz.add(quiz_data[0].first);
  //   now_quiz.add(quiz_data[0].second);
  //   now_quiz.add(quiz_data[0].third);
  //   now_quiz.add(quiz_data[0].fourth);
  //   _Answer = quiz_data[0].answer;

  //   // await Future.delayed(const Duration(seconds: 5));
  //   // print(quizdata_count);
  //   // print(quiz_data[0].answer);
  //   print(now_quiz);
  //   print(search_arr);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   input_quiz();

  //   print(quiz_data);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("リザルトページ"),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  "あなたの結果は...",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++)
                  Column(
                    children: [
                      Text(
                        widget.resultList[i],
                        style: TextStyle(
                          fontSize: 50,
                          color: widget.resultList[i] == "〇"
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),

                      Image.network(
                        widget.searchList[i],
                        width: 300,
                        height: 300,
                      ),
                      // Text(quiz_data[i].answer),
                    ],
                  ), // 各 for ループ内でカンマを追加
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.isFirst); // 最初の画面まで戻る
              },
              child: Text("ホームページに戻る"),
            ),
          ],
        ),
      ),
    );
  }
}
