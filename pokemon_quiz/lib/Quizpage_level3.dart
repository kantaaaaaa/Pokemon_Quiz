import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:pokemon_quiz/Quizpage2.dart';

class Quizpage_level3 extends StatefulWidget {
  const Quizpage_level3({Key? key, required this.level_input})
      : super(key: key);

  final String level_input; // 'text_input' プロパティを宣言

  @override
  _Quizpage createState() => _Quizpage(text_input: level_input);
}

class _Quizpage extends State<Quizpage_level3> {
  _Quizpage({required this.text_input});
  List<String> pokemon = ['ピチュー', 'ピカチュウ', 'サトシ', 'ミミッキュ'];
  String _Answer = 'ピカチュウ';
  String _userAnswer = '';
  String _result = '';

  double width = 0;
  double height = 0;
  String text_input;

  double sigma = 5;

  int _counter = 10;
  Timer? timer;

  @override
  void initState() {
    // super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          sigma -= 0.5;
          if (_counter < 1) {
            sigma = 0;
          }
          if (_counter > 0) {
            _counter--;
          } else {
            stopTimer();
            // Navigator.pop(context);
            print('タイマー終了！');
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    '時間切れ',
                    style: TextStyle(fontSize: 30),
                  ),
                  content: (Column(
                    children: [
                      Text(_Answer, style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('images/pika2.png'),
                      ),
                    ],
                  )),
                  actions: <Widget>[
                    TextButton(
                      child: Text('次の問題へ進む'),
                      onPressed: () {
                        stopTimer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Quizpage2(level_input: 'Level1')),
                        );
                      },
                    ),
                  ],
                );
              },
            );
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
              ],
            ),
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: Image.asset(
                'images/pika2.png',
                width: 100,
                height: 100,
              ),
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
                        barrierDismissible: false,
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
                                  child: Image.asset('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Quizpage2(level_input: 'Level1')),
                                  );
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
                                  child: Image.asset('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Quizpage2(level_input: 'Level1')),
                                  );
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
                                  child: Image.asset('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Quizpage2(level_input: 'Level1')),
                                  );
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
                                  child: Image.asset('images/pika2.png'),
                                ),
                              ],
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('次の問題へ進む'),
                                onPressed: () {
                                  stopTimer();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Quizpage2(level_input: 'Level1')),
                                  );
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
