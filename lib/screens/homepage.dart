import 'package:flutter/material.dart';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:myapp/screens/popup.dart';
import '../modals/guess_modal.dart';
import 'disabled_guess.dart';

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
  String guessWord = '';
  String revealAnswer = '';
  String buttonText = 'Guess me';
  late String currentGuess;
  late List<bool> correctGuessTracker;
  late List<bool> correctPositionTracker;
  int guessCountTracker = 0;

  List<TextEditingController> inputCtrls =
      List.generate(3, (_) => TextEditingController());
  List<GuessModal> guesses = List.generate(
      3,
      (_) => GuessModal(
            letters: '',
            correctGuessTracker: List.filled(3, false),
            correctPositionTracker: List.filled(3, false),
          ));

  String _generateThreeLetterWord() {
    List<String> threeLetterWords =
        nouns.where((word) => word.length == 3).toList();
    final randomIndex = Random().nextInt(threeLetterWords.length);
    return threeLetterWords[randomIndex];
  }

  void _processGuess() {
    setState(() {
      currentGuess = inputCtrls.map((ctrl) => ctrl.text).join();
      if (currentGuess == guessWord) {
        buttonText = 'Play again';
        revealAnswer = 'Answer : $guessWord';
        showDialog(
            context: context,
            builder: (_) => const ReusablePopup(
                  guessText: 'Wow!! You won 🏆🥳',
                  severity: 'success',
                ));
        _resetAll();
      } else {
        guesses[guessCountTracker] = _processCorrectGuess();
        guessCountTracker++;
        if (guessCountTracker == 3) {
          buttonText = 'Play again';
          revealAnswer = 'Answer : $guessWord';
          showDialog(
              context: context,
              builder: (_) => const ReusablePopup(
                    guessText: 'Misss!! Please try again 🫠',
                    severity: 'fail',
                  ));
          _resetAll();
        } else {
          Map<String, String> feedback = _getFeedback();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(feedback['text'] ?? 'Try Again'),
          ));
          _clearInput();
        }
      }
    });
  }

  void _clearInput() {
    inputCtrls.forEach((ctrl) => ctrl.clear());
    currentGuess = "";
    correctGuessTracker = [false, false, false];
    correctPositionTracker = [false, false, false];
  }

  void _resetAll() {
    setState(() {
      _clearInput();
      guessWord = _generateThreeLetterWord();
      revealAnswer = '';
      buttonText = 'Guess me';
      guessCountTracker = 0;
      correctGuessTracker = [false, false, false];
      correctPositionTracker = [false, false, false];
      guesses = List.generate(
          3,
          (_) => GuessModal(
                letters: '',
                correctGuessTracker: List.filled(3, false),
                correctPositionTracker: List.filled(3, false),
              ));
    });
  }

  GuessModal _processCorrectGuess() {
    if (guessWord[0] == currentGuess[0]) {
      correctPositionTracker[0] = true;
      correctGuessTracker[0] = true;
    }
    if (guessWord[1] == currentGuess[1]) {
      correctPositionTracker[1] = true;
      correctGuessTracker[1] = true;
    }
    if (guessWord[2] == currentGuess[2]) {
      correctPositionTracker[2] = true;
      correctGuessTracker[2] = true;
    }

    for (int i = 0; i < 3; i++) {
      if (!correctPositionTracker[i]) {
        // if current guess was not found at correct position find if it exists at other unique position
        for (int j = 0; j < 3; j++) {
          if (currentGuess[j] == guessWord[i] &&
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

  Map<String, String> _getFeedback() {
    final correctPositionCount =
        correctPositionTracker.where((isCorrect) => isCorrect).length;
    final correctGuessCount =
        correctGuessTracker.where((isCorrect) => isCorrect).length;

    if (correctPositionCount == 3) {
      // Case when all 3 letters are correct and in the right position
      return {'text': 'Perfect! You nailed it! 🎉', 'severity': 'success'};
    } else if (correctPositionCount == 2 && correctGuessCount == 2) {
      // Case when 2 letters are in the correct position, and one is incorrect
      return {'text': 'Great! Only one letter is off. 👍', 'severity': 'good'};
    } else if (correctPositionCount == 1 && correctGuessCount == 3) {
      // Case when 1 letter is in the correct position, and the other 2 letters are correct but in the wrong position
      return {
        'text': 'So close! Two letters are misplaced. 🤏',
        'severity': 'almost-success'
      };
    } else if (correctGuessCount == 3 && correctPositionCount == 0) {
      // Case when all letters are correct but in the wrong position
      return {
        'text': 'All letters are correct, but none in the right position! 😲',
        'severity': 'close-call'
      };
    } else if (correctGuessCount == 2 && correctPositionCount == 0) {
      // Case when two letters are correct but in the wrong position
      return {
        'text': 'Two letters are correct but misplaced. 🤔',
        'severity': 'misplaced'
      };
    } else if (correctGuessCount == 1 && correctPositionCount == 1) {
      // Case when one letter is correct and in the right position
      return {
        'text': 'One letter is in the right spot, keep going! 🔍',
        'severity': 'progress'
      };
    } else if (correctGuessCount == 1 && correctPositionCount == 0) {
      // Case when one letter is correct but in the wrong position
      return {
        'text': 'You have one correct letter, but it\'s misplaced. 🤷‍♀️',
        'severity': 'hint'
      };
    } else if (correctGuessCount == 0) {
      // Case when no letters are correct
      return {
        'text': 'No luck! Try again, none of the letters are correct. 🫠',
        'severity': 'fail'
      };
    } else {
      // Default case if no specific match
      return {
        'text': 'Keep trying, you\'re getting there! 🧐',
        'severity': 'neutral'
      };
    }
  }

  @override
  void initState() {
    super.initState();
    guessWord = _generateThreeLetterWord();
    correctGuessTracker = List.filled(3, false);
    correctPositionTracker = List.filled(3, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return _buildTextFieldContainer(inputCtrls[index]);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(revealAnswer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    )),
              ),
              ElevatedButton(
                onPressed:
                    buttonText == 'Play again' ? _resetAll : _processGuess,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      buttonText == 'Play again' ? Colors.grey : Colors.blue),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              for (var guess in guesses) DisabledGuess(guess: guess),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer(TextEditingController controller) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLength: 1,
        keyboardType: TextInputType.name,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        showCursor: false,
      ),
    );
  }
}
