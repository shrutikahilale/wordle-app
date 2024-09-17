
import 'package:flutter/material.dart';
import '../modals/guess_modal.dart';

class DisabledGuess extends StatelessWidget {
  final GuessModal guess;

  const DisabledGuess({super.key, required this.guess});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: guess.correctPositionTracker[0]
                  ? Colors.green
                  : (guess.correctGuessTracker[0]
                      ? Colors.yellow
                      : Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              guess.letters.isEmpty ? '' : guess.letters[0].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: guess.correctPositionTracker[1]
                  ? Colors.green
                  : (guess.correctGuessTracker[1]
                      ? Colors.yellow
                      : Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              guess.letters.isEmpty ? '' : guess.letters[1].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: guess.correctPositionTracker[2]
                  ? Colors.green
                  : (guess.correctGuessTracker[2]
                      ? Colors.yellow
                      : Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              guess.letters.isEmpty ? '' : guess.letters[2].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}