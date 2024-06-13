import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class branch extends StatefulWidget {
  const branch({Key? key}) : super(key: key);

  @override
  State<branch> createState() => _branch();
}

class _branch extends State<branch> {
  int _selectedAnswer = -1; // 選択肢 (-1: 未選択)
  bool _isAnswered = false; // 回答済みフラグ
  List<String> pokemon = ['ピチュー', 'ピカチュウ', 'サトシ', 'ミミッキュ'];
  String _Answer = 'ピカチュウ';
  String _userAnswer = '';
  String _result = '';

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
        title: const Text('4択クイズ'),
      ),
      body: Center(
        child: Column(
          children: [
            // 問題文
            Text('問題文'),
            const SizedBox(height: 20),
            Text(_result),
            // 選択肢ボタン
            for (int i = 0; i < 4; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userAnswer = pokemon[i];
                        _checkAnswer();
                      });
                    },
                    child: Text(pokemon[i]),
                  ),
                  const SizedBox(height: 50),
                  // Text(pokemon[i]),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final int i;
  final bool isSelected;
  final bool isAnswered;
  final VoidCallback onTap;

  const ChoiceButton({
    Key? key,
    required this.i,
    required this.isSelected,
    required this.isAnswered,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ボタン本体
        ElevatedButton(
          onPressed: isAnswered ? null : onTap,
          child: Text('選択肢 ${i + 1}'),
        ),
        // 〇/バツを重ねる
        if (isAnswered)
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: isSelected,
              child: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
        if (isAnswered)
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: !isSelected,
              child: Icon(Icons.cancel, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
