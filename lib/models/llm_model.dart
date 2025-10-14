class LlmModel {
  final String id;
  final String modelName;
  final String description;

  LlmModel({
    required this.id,
    required this.modelName,
    required this.description,
  });

  LlmModel copyWith({
    String? id,
    String? modelName,
    String? description,
  }) {
    return LlmModel(
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      description: description ?? this.description,
    );
  }
}
