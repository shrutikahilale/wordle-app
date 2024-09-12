// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String guessWord = 'sit';

  late String currentGuess;
  late List<bool> correctGuessTracker;
  late List<bool> correctPositionTracker;

  GuessModal guess1 = GuessModal(
    letters: '',
    correctGuessTracker: List.filled(3, false),
    correctPositionTracker: List.filled(3, false),
  );
  GuessModal guess2 = GuessModal(
    letters: '',
    correctGuessTracker: List.filled(3, false),
    correctPositionTracker: List.filled(3, false),
  );
  GuessModal guess3 = GuessModal(
    letters: '',
    correctGuessTracker: List.filled(3, false),
    correctPositionTracker: List.filled(3, false),
  );

  int guessCountTracker = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentGuess = '';
      correctGuessTracker = [false, false, false];
      correctPositionTracker = [false, false, false];
    });
  }

  void _print() {
    setState(() {
      currentGuess = inputCtrl1.text + inputCtrl2.text + inputCtrl3.text;
      if (guessCountTracker == 0) {
        guess1 = _processCorrectGuess();
      } else if (guessCountTracker == 1) {
        guess2 = _processCorrectGuess();
      } else if (guessCountTracker == 2) {
        guess3 = _processCorrectGuess();
      } else {
        // show result if user was able to guess or not
      }
      guessCountTracker++;
      _clearInput();
    });
  }

  void _clearInput() {
    inputCtrl1.clear();
    inputCtrl2.clear();
    inputCtrl3.clear();
    currentGuess = "";
    correctGuessTracker = [false, false, false];
    correctPositionTracker = [false, false, false];
  }

  GuessModal _processCorrectGuess() {
    if (guessWord[0] == currentGuess[0]) {
      correctPositionTracker[0] = true;
    }
    if (guessWord[1] == currentGuess[1]) {
      correctPositionTracker[1] = true;
    }
    if (guessWord[2] == currentGuess[2]) {
      correctPositionTracker[2] = true;
    }

    for (int i = 0; i < 3; i++) {
      if (!correctPositionTracker[i]) {
        // if current guess was not found at correct position find if it exists at other unique position
        for (int j = 0; j < 3; j++) {
          if (currentGuess[i] == guessWord[j] &&
              !correctPositionTracker[j] &&
              !correctGuessTracker[j]) {
            // handling the same letter case,
            // might have been marked by correctGuessTracker of correctPositionTracker
            correctGuessTracker[j] = true;
          }
        }
      }
    }

    return GuessModal(
      letters: currentGuess,
      correctGuessTracker: correctGuessTracker,
      correctPositionTracker: correctPositionTracker,
    );
  }

  TextEditingController inputCtrl1 = TextEditingController();
  TextEditingController inputCtrl2 = TextEditingController();
  TextEditingController inputCtrl3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: inputCtrl1,
                    maxLength: 1,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: "",
                    ),
                    showCursor: false,
                  ),
                ),
                Container(
                  width: 40,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: inputCtrl2,
                    maxLength: 1,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(counterText: ""),
                    showCursor: false,
                  ),
                ),
                Container(
                  width: 40,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: inputCtrl3,
                    maxLength: 1,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(counterText: ""),
                    showCursor: false,
                  ),
                ),
              ],
            ),
            DisabledGuess(guess: guess1),
            DisabledGuess(guess: guess2),
            DisabledGuess(guess: guess3),
            ElevatedButton(
              onPressed: _print,
              child: Text('Guess me'),
            ),
          ],
        ),
      ),
    );
  }
}

class GuessModal {
  late String letters;
  late List<bool> correctGuessTracker;
  late List<bool> correctPositionTracker;
  GuessModal(
      {required this.letters,
      required this.correctGuessTracker,
      required this.correctPositionTracker});
}

class DisabledGuess extends StatelessWidget {
  final GuessModal guess;

  const DisabledGuess({super.key, required this.guess});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: guess.correctPositionTracker[0]
                  ? Colors.green
                  : (guess.correctGuessTracker[0]
                      ? Colors.yellow
                      : Colors.grey)),
          child: Text(
            guess.letters.isEmpty ? '' : guess.letters[0].toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 40,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: guess.correctPositionTracker[1]
                  ? Colors.green
                  : (guess.correctGuessTracker[1]
                      ? Colors.yellow
                      : Colors.grey)),
          child: Text(
            guess.letters.isEmpty ? '' : guess.letters[1].toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 40,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: guess.correctPositionTracker[2]
                  ? Colors.green
                  : (guess.correctGuessTracker[2]
                      ? Colors.yellow
                      : Colors.grey)),
          child: Text(
            guess.letters.isEmpty ? '' : guess.letters[2].toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
