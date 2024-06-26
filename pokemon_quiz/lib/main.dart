import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pokemon_quiz/Quizpage.dart';
import 'package:pokemon_quiz/branch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ImagePickerExample.dart';
import 'Quizlistpage.dart';
import 'Quizpage_level3.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// void timer() {
//   Timer(const Duration(seconds: 5), handleTimeout);
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// class Data {
//   int num;

//   Data({required this.num});
// }

class _MyHomePageState extends State<MyHomePage> {
  String firebaseText = '';

  void _viewfirebase() {
    final db = FirebaseFirestore.instance;

    db.collection("soccer_players").get().then((event) {
      String text = '';
      int loop_count = 0;

      for (var doc in event.docs) {
        print("${doc.data().values}");
        text += doc.data().values.toString();
        loop_count++;
      }
      print(loop_count);

      setState(() {
        firebaseText = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    )
                  },
              icon: const Icon(
                Icons.login_outlined,
                color: Colors.blue,
              )),
          const SizedBox(
            width: 50,
          )
        ],
      ),
      body: Container(
        // color: Colors.amber,
        height: 300,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Hello World')
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .shimmer(),
              // Image.network(
              //   "images/usokki-.png",
              //   width: 100,
              //   height: 100,
              // ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImagePickerExample()),
                  );
                },
                child: Text('画像お試しページ'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Quizpage(level_input: 'Level1')),
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
                        builder: (context) => Quizpage(level_input: 'Level2')),
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
                    MaterialPageRoute(builder: (context) => QuziListtPage()),
                  );
                },
                child: Text('クイズデータ一覧ページ'),
              ),
              ElevatedButton(
                onPressed: () {
                  // ここにボタンを押した時に呼ばれるコードを書く
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => branch()),
                  );
                },
                child: Text('グリッドビューテストページ'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     // ここにボタンを押した時に呼ばれるコードを書く
              //     _addfirebase();
              //   },
              //   child: Text('firestoreに追加'),
              // ),
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
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
