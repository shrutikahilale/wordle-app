class GuessModal {
  late String letters;
  late List<bool> correctGuessTracker;
  late List<bool> correctPositionTracker;
  GuessModal({
    required this.letters,
    required this.correctGuessTracker,
    required this.correctPositionTracker,
  });
}
