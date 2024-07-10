import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_quiz/Quizpage.dart';
import 'package:pokemon_quiz/branch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ImagePickerExample.dart';
import 'Quizlistpage.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(UIDProvider);

    TAP(WidgetRef ref) {
      final notifier = ref.read(UIDProvider.notifier);
      notifier.state = "aaaaaaa";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        //title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => login(), // アイコンタップ時にポップアップを表示
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
        height: 300,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(uid)
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .shimmer(),
              ElevatedButton(
                  onPressed: () {
                    TAP(ref);
                  },
                  child: Text("変更")),
              const SizedBox(height: 20),
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
                    MaterialPageRoute(
                        builder: (context) => SearchWidget(
                              uid: uid,
                            )),
                  );
                },
                child: Text('検索テストページ'),
              ),
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
