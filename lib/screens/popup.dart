import 'package:flutter/material.dart';

class ReusablePopup extends StatelessWidget {
  final String guessText;
  final String severity;

  const ReusablePopup({
    required this.guessText,
    required this.severity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          severity == 'success' ? Colors.lightGreen : Colors.redAccent,
      title: Text(
        guessText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child:
              const Text('Play Again', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
