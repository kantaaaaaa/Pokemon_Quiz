// import 'dart:async';
// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:pokemon_quiz/Quizpage.dart';
// import 'package:pokemon_quiz/testpage.dart';
// import 'package:pokemon_quiz/branch.dart';


// class Resultpage extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// // void timer() {
// //   Timer(const Duration(seconds: 5), handleTimeout);
// // }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// // class Data {
// //   int num;

// //   Data({required this.num});
// // }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.errorContainer,
//         title: Text(widget.title),
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
//               // Image.asset('iamges/upa-.png'),
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
//                         builder: (context) => Quizpage(level_input: 'Level3')),
//                   );
//                 },
//                 child: Text('Level3'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // ここにボタンを押した時に呼ばれるコードを書く
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => TestPage()),
//                   );
//                 },
//                 child: Text('タイマーテスト'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // ここにボタンを押した時に呼ばれるコードを書く
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => branch()),
//                   );
//                 },
//                 child: Text('タイマーテスト'),
//               ),
//             ],
//           ),
//         ),
//       ),

//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
