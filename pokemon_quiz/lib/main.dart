import 'dart:async';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_quiz/Quizpage.dart';
import 'package:pokemon_quiz/branch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Quizlistpage.dart';
import 'Quizpage_level1.dart';
import 'Quizpage_level3.dart';
import 'favorite_quiz.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import 'login.dart';
import 'searchtest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const app = MaterialApp(home: MyApp());
  const scope = ProviderScope(child: app);
  runApp(scope);
}

final UIDProvider = StateProvider<String>((ref) {
  return "null";
});

final Login_Result_Provider = StateProvider<String>((ref) {
  return "ログインしてないよ";
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(UIDProvider);
    final _login_result = ref.watch(Login_Result_Provider);
    // ログインID
    String LoginEmail = "";
    // パスワード
    String LoginPassword = "";
    // ログインメッセージ
    String LoginMessage = "Not Login";

    void _showLoginPopup(BuildContext context) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext context) {
          return Container(
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 500), // アニメーション時間を500ミリ秒に変更
              curve: Curves.easeInOut, // アニメーションカーブをeaseInOutに変更
              transform: Matrix4.identity()..translate(0.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // コンテンツの高さを制限
                  children: [
                    // メールアドレス入力欄
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'メールアドレス',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String inputValue) {
                        // 値が変更された際に入力内容を変数に保持
                        LoginEmail = inputValue;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),

                    // パスワード入力欄
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String inputValue) {
                        // 値が変更された際に入力内容を変数に保持
                        LoginPassword = inputValue;
                      },
                      //obscureText: !_passwordVisible, // パスワードを非表示
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20.0),

                    // ログインボタン
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          // Firebase認証処理
                          final UserCredential result = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: LoginEmail, password: LoginPassword);
                          // ログイン成功時にはユーザーを取得
                          final User user = result.user!;
                          final String uids = user.uid;
                          LoginMessage = "ハッピーハッピーハッピー - ${uids}";
                          final notifier = ref.read(UIDProvider.notifier);
                          notifier.state = uids;

                          final login_notifier =
                              ref.read(Login_Result_Provider.notifier);
                          login_notifier.state = "ログインできたお";

                          Navigator.pop(context);
                        } catch (e) {
                          // ログイン失敗時
                          LoginMessage = "失敗 - ${e.toString()}";
                        }
                        // ポップアップを閉じる
                      },
                      child: const Text('ログイン'),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    bool _passwordVisible = false; // パスワード表示状態

    // TAP(WidgetRef ref) {
    //   final notifier = ref.read(UIDProvider.notifier);
    //   notifier.state = "aaaaaaa";
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: Text(_login_result),
        actions: [
          IconButton(
            onPressed: () {
              _showLoginPopup(context);
            }, // アイコンタップ時にポップアップを表示
            icon: const Icon(
              Icons.login_outlined,
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            width: 50,
          )
        ],
      ),
      body: Container(
        // color: Colors.amber,
        height: 400,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ポケモンクイズ",
                style: TextStyle(fontSize: 80),
              ),
              // Text(uid)
              //     .animate(
              //       onPlay: (controller) => controller.repeat(),
              //     )
              //     .shimmer(),
              // ElevatedButton(
              //     onPressed: () {
              //       TAP(ref);
              //     },
              //     child: Text("変更")),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Quizpage_level1(level_input: 'Level1')),
                  );
                },
                child: Text('Level1'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Quizpage_level3(level_input: 'Level3')),
                  );
                },
                child: Text('Level2'),
              ),
              const SizedBox(height: 60),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // ここにボタンを押した時に呼ばれるコードを書く
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizListtPage(
                                  uid: uid,
                                )),
                      );
                    },
                    child: Text('クイズデータ一覧ページ'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // ここにボタンを押した時に呼ばれるコードを書く
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Favorite_quiz_Page(
                                  uid: uid,
                                )),
                      );
                    },
                    child: Text('お気に入りクイズデータ一覧'),
                  ),
                ],
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     // ここにボタンを押した時に呼ばれるコードを書く
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => SearchWidget()),
              //     );
              //   },
              //   child: Text('検索テストページ'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//     required this.title,
//   });

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String firebaseText = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.errorContainer,
//         //title: Text(widget.title),
//         actions: [
//           IconButton(
//               onPressed: () => {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => login()),
//                     )
//                   },
//               icon: const Icon(
//                 Icons.login_outlined,
//                 color: Colors.blue,
//               )),
//           const SizedBox(
//             width: 50,
//           )
//         ],
//       ),
//       body: Container(
//         // color: Colors.amber,
//         height: 300,
//         width: double.infinity,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text("uid")
//                   .animate(
//                     onPlay: (controller) => controller.repeat(),
//                   )
//                   .shimmer(),
//               Image.network(
//                 "images/usokki-.png",
//                 width: 100,
//                 height: 100,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ImagePickerExample()),
//                   );
//                 },
//                 child: Text('画像お試しページ'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => Quizpage(level_input: 'Level1')),
//                   );
//                 },
//                 child: Text('Level1'),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => Quizpage(level_input: 'Level2')),
//                   );
//                 },
//                 child: Text('Level2'),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             Quizpage_level3(level_input: 'Level3')),
//                   );
//                 },
//                 child: Text('Level3'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // ここにボタンを押した時に呼ばれるコードを書く
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => QuizListtPage()),
//                   );
//                 },
//                 child: Text('クイズデータ一覧ページ'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // ここにボタンを押した時に呼ばれるコードを書く
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => branch()),
//                   );
//                 },
//                 child: Text('グリッドビューテストページ'),
//               ),
//             ],
//           ),
//         ),
//       ),

//     );
//   }
// }
