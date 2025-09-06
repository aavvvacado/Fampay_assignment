import 'card_model.dart';

class CardGroup {
  final int id;
  final String? name;
  final String designType;
  final int? cardType;
  final List<CardModel> cards;
  final bool isScrollable;
  final double? height;
  final bool isFullWidth;
  final String? slug;
  final int? level;

  CardGroup({
    required this.id,
    this.name,
    required this.designType,
    this.cardType,
    required this.cards,
    required this.isScrollable,
    this.height,
    this.isFullWidth = false,
    this.slug,
    this.level,
  });

  factory CardGroup.fromJson(Map<String, dynamic> json) {
    return CardGroup(
      id: json['id'],
      name: json['name'],
      designType: json['design_type'] ?? '',
      cardType: json['card_type'],
      cards: (json['cards'] as List)
          .map((e) => CardModel.fromJson(e))
          .toList(),
      isScrollable: json['is_scrollable'] ?? false,
      height: (json['height'] as num?)?.toDouble(),
      isFullWidth: json['is_full_width'] ?? false,
      slug: json['slug'],
      level: json['level'],
    );
  }
}
