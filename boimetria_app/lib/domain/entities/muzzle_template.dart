class MuzzleTemplate {
  const MuzzleTemplate({
    required this.id,
    required this.bovineId,
    required this.modelVersion,
    required this.capturedAt,
    this.cropPath,
  });

  final int id;
  final int bovineId;
  final String modelVersion;
  final DateTime capturedAt;
  final String? cropPath;

  bool needsReembedding(String currentModel) => modelVersion != currentModel;

  @override
  bool operator ==(Object other) => other is MuzzleTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
