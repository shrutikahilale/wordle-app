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
          severity == 'success' ? const Color.fromARGB(255, 68, 255, 171) :  const Color.fromARGB(255, 255, 59, 128),
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
          child: Text(
            severity == 'success' ? 'Yayy 🙌🥳' : 'Okay 🫠',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
