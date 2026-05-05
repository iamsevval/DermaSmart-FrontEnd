enum QuestionType { single, multi, branching }

class QuizOption {
  final String text;
  final String? subtitle;

  QuizOption({required this.text, this.subtitle});
}

class QuestionModel {
  final String id;
  final String questionText;
  final List<QuizOption> options;
  final QuestionType type;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    this.type = QuestionType.single,
  });
}
