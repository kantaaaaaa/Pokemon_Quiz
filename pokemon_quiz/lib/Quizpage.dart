import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'Pokemondata.dart';
import 'Quizpage_popup.dart';

class Quizpage extends StatefulWidget {
  const Quizpage({Key? key, required this.level_input}) : super(key: key);

  final String level_input; // 'text_input' プロパティを宣言

  @override
  _Quizpage createState() => _Quizpage(text_input: level_input);
}

class _Quizpage extends State<Quizpage> {
  _Quizpage({required this.text_input});
  List<String> pokemon = ['ピチュー', 'ピカチュウ', 'サトシ', 'ミミッキュ'];
  String _Answer = 'ピカチュウ';
  String _userAnswer = '';
  String _result = '';

  double width = 0;
  double height = 0;
  String text_input;

  int _counter = 10;
  Timer? timer;

  List<Quiz_data> quiz_data = [];

  void _viewfirebase() async {
    final db = FirebaseFirestore.instance;

    final event = await db.collection('Quizdata').get();
    //final event = await db.collection("Quizdata").get();
    final docs = event.docs;
    final pokemon_data =
        docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();

    setState(() {
      this.quiz_data += pokemon_data;
      print(pokemon_data);
    });
  }

  @override
  void initState() {
    super.initState();
    _viewfirebase();
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
            // timeout(context, "ピカチュウ", 'images/pika2.png');
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

  void _checkAnswer() {
    setState(() {
      if (_userAnswer == _Answer) {
        _result = '正解';
      } else {
        _result = '不正解';
      }
    });
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
                const SizedBox(width: 1100),
                Text(
                  _counter.toString(),
                  style: TextStyle(fontSize: 50, color: Colors.amber),
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
                Text(quiz_data[2].answer)
              ],
            ),
            SizedBox(
              height: 100,
              width: 500,
              child: Image.network('images/deguda.png'),
            ),
            Text(_result),
            // AnimatedContainer(
            //   // 1.アニメーションの動作時間
            //   duration: Duration(seconds: 1),
            //   // 2.変化させたいプロパティ
            //   width: width,
            //   height: height,
            //   color: Colors.red,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userAnswer = pokemon[0];
                      _checkAnswer();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              _result,
                              style: TextStyle(fontSize: 30),
                            ),
                            content: (Column(
                              children: [
                                Text(_Answer, style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Image.network('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           Quizpage2(level_input: 'Level1')),
                                  // );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           Quizpage2(level_input: 'Level1')),
                    // );
                  },
                  child: Text(pokemon[0]),
                ),
                const SizedBox(width: 100),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userAnswer = pokemon[1];
                      _checkAnswer();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              _result,
                              style: TextStyle(fontSize: 30),
                            ),
                            content: (Column(
                              children: [
                                Text(_Answer, style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Image.network('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           Quizpage2(level_input: 'Level1')),
                                  // );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                  child: Text(pokemon[1]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userAnswer = pokemon[2];
                      _checkAnswer();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              _result,
                              style: TextStyle(fontSize: 30),
                            ),
                            content: (Column(
                              children: [
                                Text(_Answer, style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Image.network('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           Quizpage2(level_input: 'Level1')),
                                  // );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                  child: Text(pokemon[2]),
                ),
                const SizedBox(width: 100),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userAnswer = pokemon[3];
                      _checkAnswer();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              _result,
                              style: TextStyle(fontSize: 30),
                            ),
                            content: (Column(
                              children: [
                                Text(_Answer, style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Image.network('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           Quizpage2(level_input: 'Level1')),
                                  // );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                  child: Text(pokemon[3]),
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
