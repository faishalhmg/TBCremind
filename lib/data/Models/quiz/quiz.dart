class Quiz {
  int id;
  String quizTitle;
  // Other properties

  Quiz({
    required this.id,
    required this.quizTitle,
    // Other constructor parameters
  });

  // Factory method to create a Quiz object from JSON data
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      quizTitle: json['quiz_title'],
      // Assign other JSON properties to corresponding model properties
    );
  }

  // Convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_title': quizTitle,
      // Convert other model properties to JSON
    };
  }
}

class Question {
  String questionText;
  List<Answer>? answers;

  Question({
    required this.questionText,
    this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Answer>? answerList;
    if (json['answers'] != null) {
      answerList = List<Answer>.from(
          json['answers'].map((answer) => Answer.fromJson(answer)));
    }

    return Question(
      questionText: json['question_text'],
      answers: answerList,
    );
  }
}

class Answer {
  String answerText;
  int isCorrect;

  Answer({
    required this.answerText,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerText: json['answer_text'],
      isCorrect: json['is_correct'],
    );
  }
}
