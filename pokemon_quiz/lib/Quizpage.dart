import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class Quizpage extends StatefulWidget {
  const Quizpage({Key? key, required this.level_input}) : super(key: key);

  final String level_input; // 'text_input' プロパティを宣言

  @override
  _Quizpage createState() => _Quizpage(text_input: level_input);
}

class _Quizpage extends State<Quizpage> {
  _Quizpage({required this.text_input});

  String text_input;

  int _counter = 10;
  Timer? timer;

  @override
  void initState() {
    // super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_counter > 0) {
            _counter--;
          } else {
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ネクストページだにょ"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(height: 50),
                Text(
                  text_input,
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  _counter.toString(),
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Qこのポケモンはだれ？',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 100,
              width: 500,
              child: Image.asset('iamges/pika2.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('ピチュー'),
                ),
                const SizedBox(width: 100),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('ピカチュウ'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('サトシ'),
                ),
                const SizedBox(width: 100),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('ミミッキュ'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                stopTimer();
                Navigator.pop(context);
              },
              child: Text("戻れるよん"),
            ),
          ],
        ),
      ),
    );
  }
}
