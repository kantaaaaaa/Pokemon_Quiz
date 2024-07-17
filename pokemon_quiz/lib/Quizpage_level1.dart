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
import 'Resultpage.dart';

class Quizpage_level1 extends StatefulWidget {
  const Quizpage_level1({Key? key, required this.level_input})
      : super(key: key);

  final String level_input; // 'text_input' プロパティを宣言

  @override
  _Quizpage_level1 createState() => _Quizpage_level1(text_input: level_input);
}

class _Quizpage_level1 extends State<Quizpage_level1> {
  _Quizpage_level1({required this.text_input});
  List<String> pokemon = ['ピチュー', 'ピカチュウ', 'サトシ', 'ミミッキュ'];
  List<String> pokemon_view = [];
  String _Answer = '';
  // String _userAnswer = '';
  String _result = '';
  int loop_index = 0;
  List<String> result_arr = [];

  String load = "false";
  //final quizdata_count = 0;

  double width = 0;
  double height = 0;
  String text_input;

  int _counter = 10;
  Timer? timer;
  int quiz_count = 0;

  List<int> search_arr = [];
  List<Quiz_data> quiz_data = [];

  List<String> now_quiz = [];

  List<int> generateRandomList(int max) {
    // 生成した値を保持するSet
    final Set<int> generatedNumbers = {};

    // ランダムな値をlength個生成
    while (generatedNumbers.length < 3) {
      final randomNumber = Random().nextInt(max) + 1;
      generatedNumbers.add(randomNumber);
    }

    // Setからリストへ変換
    return generatedNumbers.toList();
  }

  void input_quiz() async {
    for (var element in search_arr) {
      final db = FirebaseFirestore.instance;
      final event = await db
          .collection('Quizdata')
          .where('quiz_id', isEqualTo: element)
          .get();
      final docs = event.docs;
      final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();
      this.quiz_data += pokemon;
      //print(quiz_data);
    }
  }

  // いっそのことこの関数の中で全部やっちゃおう
  void firedata() async {
    final quizdata_count = await addfirebase_method();
    int? value = quizdata_count;
    search_arr = generateRandomList(value!);
    input_quiz();

    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        load = "true";
        _counter += 3;
      });
    });
    now_quiz.add(quiz_data[0].first);
    now_quiz.add(quiz_data[0].second);
    now_quiz.add(quiz_data[0].third);
    now_quiz.add(quiz_data[0].fourth);
    _Answer = quiz_data[0].answer;
    pokemon_view.add(quiz_data[0].imgURL);
    pokemon_view.add(quiz_data[1].imgURL);
    pokemon_view.add(quiz_data[2].imgURL);

    // await Future.delayed(const Duration(seconds: 5));
    // print(quizdata_count);
    // print(quiz_data[0].answer);
    print(now_quiz);
    print(search_arr);
  }

  @override
  void initState() {
    super.initState();
    firedata();

    //print(quizdata_count);
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
            //showD(context);
            timeout(context, _Answer, "時間切れ", quiz_data[loop_index].imgURL);
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

  void re_quiz() {
    now_quiz = [];
    now_quiz.add(quiz_data[loop_index].first);
    now_quiz.add(quiz_data[loop_index].second);
    now_quiz.add(quiz_data[loop_index].third);
    now_quiz.add(quiz_data[loop_index].fourth);
  }

  void _checkAnswer(String _userAnswer) {
    print(_userAnswer);
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
        title: Text("level1"),
      ),
      body: Center(
        child: Column(
          children: [
            if (load == "true")
              Center(
                child: Column(
                  children: [
                    Row(
                      children: [
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
                    SizedBox(
                      height: 100,
                      width: 500,
                      child: Image.network(quiz_data[loop_index].imgURL),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 上段のボタン
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 2; i++)
                              ElevatedButton(
                                child: Text(now_quiz[i]),
                                onPressed: () {
                                  _checkAnswer(now_quiz[i]);
                                  timeout(context, _Answer, _result,
                                      quiz_data[loop_index].imgURL);
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(150, 30), // ボタンのサイズを固定
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // 下段のボタン
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 2; i < 4; i++)
                              ElevatedButton(
                                onPressed: () {
                                  _checkAnswer(now_quiz[i]);
                                  timeout(context, _Answer, _result,
                                      quiz_data[loop_index].imgURL);
                                },
                                child: Text(now_quiz[i]),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(150, 30), // ボタンのサイズを固定
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
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
              )
            else
              Column(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Text(
                    "ロード中",
                    style: TextStyle(fontSize: 50),
                  ),
                  AnimatedRotation(
                    turns: 1.0, // 回転回数
                    duration: Duration(seconds: 1), // 回転にかかる時間
                    child: Image.network(
                      'images/pika2.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void timer_reset() {
    _counter = 10;
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
            //showD(context);
            timeout(context, _Answer, "時間切れ", quiz_data[loop_index].imgURL);
          }
        });
      },
    );
  }

  void timeout(BuildContext context, String _Answer_result, String title_text,
      String _image) {
    stopTimer();
    if (title_text == "正解") {
      result_arr.add("〇");
    } else {
      result_arr.add("X");
    }
    print(result_arr);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title_text,
            style: TextStyle(fontSize: 30),
          ),
          content: (Column(
            children: [
              Text(_Answer_result, style: TextStyle(fontSize: 40)),
              SizedBox(
                height: 300,
                width: 300,
                child: Image.network(_image),
              ),
            ],
          )),
          actions: <Widget>[
            if (loop_index < 2)
              TextButton(
                child: Text('次の問題へ進む'),
                onPressed: () {
                  setState(() {
                    //if文書いてリザルトページに飛ばす
                    loop_index++;
                    re_quiz();
                    timer_reset();
                    _Answer = quiz_data[loop_index].answer;
                    Navigator.pop(context);
                  });
                },
              ),
            if (loop_index > 1)
              TextButton(
                child: Text('結果を見る'),
                onPressed: () {
                  setState(() {
                    //if文書いてリザルトページに飛ばす
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Resultpage(
                                resultList: result_arr,
                                searchList: pokemon_view,
                              )),
                    );
                  });
                },
              ),
          ],
        );
      },
    );
  }
}
