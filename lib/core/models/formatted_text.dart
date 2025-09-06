class FormattedText {
  final String text;
  final String align;
  final List<dynamic>? entities;

  FormattedText({required this.text, required this.align, this.entities});

  factory FormattedText.fromJson(Map<String, dynamic> json) {
    return FormattedText(
      text: json['text'] ?? '',
      align: json['align'] ?? 'left',
      entities: json['entities'],
    );
  }
}
