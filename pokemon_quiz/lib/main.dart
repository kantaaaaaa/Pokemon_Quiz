import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Quizpage_level3.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pokemon_quiz/Quizpage.dart';
import 'package:pokemon_quiz/testpage.dart';
import 'package:pokemon_quiz/branch.dart';

void main() async {
  // Firebaseの初期化を待機
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// ログインID・パスワードの値を使うのでStatefullWidgetに変更
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ログインID
  String LoginEmail = "";
  // パスワード
  String LoginPassword = "";
  // ログインメッセージ
  String LoginMessage = "Not Login";
  String firebaseText = '';

  void _addfirebase() {
    final db = FirebaseFirestore.instance;
    final soccer_player = <String, dynamic>{
      "name": "伊藤ひろき",
      "team": "バイエルン",
      "position": "SB,CB",
      "age": 25
    };

    db.collection("soccer_players").add(soccer_player).then(
        (DocumentReference doc) => print("Error writing document: ${doc.id}"));
  }

  void _viewfirebase() {
    final db = FirebaseFirestore.instance;

    db.collection("soccer_players").get().then((event) {
      String text = '';

      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        text += doc.data().toString();
      }

      setState(() {
        firebaseText = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Flutter'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Image.asset('images/pika2.png'),
                    ),
                    // Image.asset('iamges/upa-.png'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Quizpage(level_input: 'Level1')),
                        );
                      },
                      child: Text('Level1'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Quizpage(level_input: 'Level2')),
                        );
                      },
                      child: Text('Level2'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Quizpage_level3(level_input: 'Level3')),
                        );
                      },
                      child: Text('Level3'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // ここにボタンを押した時に呼ばれるコードを書く
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TestPage()),
                        );
                      },
                      child: Text('タイマーテスト'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // ここにボタンを押した時に呼ばれるコードを書く
                        _addfirebase();
                      },
                      child: Text('firestoreに追加'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // ここにボタンを押した時に呼ばれるコードを書く
                        _viewfirebase();
                      },
                      child: Text('firestoreのデータを表示'),
                    ),
                    Text(
                      '${firebaseText}',
                    ),
                  ],
                ),
              ),
              // メールアドレス入力欄
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String inputValue) {
                  // 値が変更された際に入力内容を変数に保持
                  setState(() {
                    LoginEmail = inputValue;
                  });
                },
              ),
              // パスワード入力欄
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String inputValue) {
                  // 値が変更された際に入力内容を変数に保持
                  setState(() {
                    LoginPassword = inputValue;
                  });
                },
              ),

//...
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Firebase認証処理
                    final UserCredential result = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: LoginEmail, password: LoginPassword);
                    // ログイン成功時にはユーザーを取得
                    final User user = result.user!;
                    setState(() {
                      LoginMessage = "ログイン成功 - ${user.email}";
                    });
                  } catch (e) {
                    // ログイン失敗時
                    setState(() {
                      LoginMessage = "ログイン失敗 - ${e.toString()}";
                    });
                  }
                },
                child: Text("Auth"),
              ),
//...

              Text(LoginMessage)
            ],
          ),
        ),
      ),
    );
  }
}
