import 'dart:ffi';

class QuestionDetails {
  late String questionID;
  late String questionDomain;
  late String question;
  late bool optionRequired;
  late Map<Int, String> options;
  late bool mediaRequired;
  late String mediaLink;
  late Int marks;
  late Int negativeMarks;
  QuestionDetails({
    required this.questionID,
    required this.questionDomain,
    required this.question,
    required this.optionRequired,
    required this.options,
    required this.mediaRequired,
    required this.mediaLink,
    required this.marks,
    required this.negativeMarks,
  });
}
