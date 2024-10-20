class QuestionDetails {
  final String questionID;
  final String questionDomain;
  final String question;
  final bool optionRequired;
  final Map<dynamic, dynamic> options;
  int correctOption;
  final bool mediaRequired;
  final String mediaLink;
  final bool descriptionRequired;
  final int marks;
  final int negativeMarks;

  QuestionDetails({
    required this.questionID,
    required this.questionDomain,
    required this.question,
    required this.optionRequired,
    required this.options,
    required this.correctOption,
    required this.mediaRequired,
    required this.mediaLink,
    required this.descriptionRequired,
    required this.marks,
    required this.negativeMarks,
  });
}
