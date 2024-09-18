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
    return threeLetterWords[randomIndex].toLowerCase();
  }

  void _onPressGuessMe() {
    if (_validateInput()) {
      _processGuess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the fileds')));
    }
  }

  bool _validateInput() {
    bool isValidInput = true;
    for (var ctrl in inputCtrls) {
      isValidInput &= ctrl.text.trim().isNotEmpty;
    }
    return isValidInput;
  }

  void _processGuess() {
    setState(() {
      currentGuess = inputCtrls.map((ctrl) => ctrl.text.toLowerCase()).join();
      guesses[guessCountTracker] = _processCorrectGuess();

      if (currentGuess == guessWord) {
        buttonText = 'Play again';
        showDialog(
            context: context,
            builder: (_) => const ReusablePopup(
                  guessText: 'Wow!! You won 🏆🥳',
                  severity: 'success',
                ));
      } else {
        guessCountTracker++;
        if (guessCountTracker == 3) {
          buttonText = 'Play again';
          showDialog(
              context: context,
              builder: (_) => ReusablePopup(
                    guessText: 'The correct answer is $guessWord',
                    severity: 'fail',
                  ));
        } else {
          _clearInput();
        }
      }
    });
  }

  void _clearInput() {
    for (var ctrl in inputCtrls) {
      ctrl.clear();
    }
    currentGuess = "";
    correctGuessTracker = [false, false, false];
    correctPositionTracker = [false, false, false];
  }

  void _resetAll() {
    setState(() {
      _clearInput();
      guessWord = _generateThreeLetterWord();
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
              ElevatedButton(
                onPressed:
                    buttonText == 'Play again' ? _resetAll : _onPressGuessMe,
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
