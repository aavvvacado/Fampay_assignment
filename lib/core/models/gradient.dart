class GradientModel {
  final int angle;
  final List<String> colors;

  GradientModel({required this.angle, required this.colors});

  factory GradientModel.fromJson(Map<String, dynamic> json) {
    return GradientModel(
      angle: json['angle'] ?? 0,
      colors: (json['colors'] as List).cast<String>(),
    );
  }
}
