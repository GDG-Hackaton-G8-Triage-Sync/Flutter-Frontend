class TriageResult {
  TriageResult();
  factory TriageResult.fromJson(Map<String, dynamic> json) => TriageResult();
}

class SymptomSubmission {
  final String description;
  SymptomSubmission({required this.description});
  Map<String, dynamic> toJson() => {'description': description};
}
