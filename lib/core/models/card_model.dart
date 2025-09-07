import 'card_image.dart';
import 'formatted_text.dart';
import 'gradient.dart';

class CardModel {
  final int id;
  final String? name;
  final String? slug;

  final String? title;
  final FormattedText? formattedTitle;

  final String? description;
  final FormattedText? formattedDescription;

  final CardImage? bgImage;
  final GradientModel? bgGradient;
  final String? bgColor;

  final CardImage? icon;
  final double? iconSize;

  final List<dynamic>? cta; // You can later model CTA properly
  final List<dynamic>? positionalImages;
  final List<dynamic>? components;

  final String? url;
  final bool isDisabled;
  final bool isShareable;
  final bool isInternal;

  // Additional properties from API
  final String? cardType;
  final int? level;

  CardModel({
    required this.id,
    this.name,
    this.slug,
    this.title,
    this.formattedTitle,
    this.description,
    this.formattedDescription,
    this.bgImage,
    this.bgGradient,
    this.bgColor,
    this.icon,
    this.iconSize,
    this.cta,
    this.positionalImages,
    this.components,
    this.url,
    this.isDisabled = false,
    this.isShareable = false,
    this.isInternal = false,
    this.cardType,
    this.level,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      title: json['title'],
      formattedTitle: json['formatted_title'] != null
          ? FormattedText.fromJson(json['formatted_title'])
          : null,
      description: json['description'],
      formattedDescription: json['formatted_description'] != null
          ? FormattedText.fromJson(json['formatted_description'])
          : null,
      bgImage: json['bg_image'] != null
          ? CardImage.fromJson(json['bg_image'])
          : null,
      bgGradient: json['bg_gradient'] != null
          ? GradientModel.fromJson(json['bg_gradient'])
          : null,
      bgColor: json['bg_color'],
      icon: json['icon'] != null ? CardImage.fromJson(json['icon']) : null,
      iconSize: json['icon_size'] != null
          ? (json['icon_size'] as num).toDouble()
          : null,
      cta: json['cta'],
      positionalImages: json['positional_images'],
      components: json['components'],
      url: json['url'],
      isDisabled: json['is_disabled'] ?? false,
      isShareable: json['is_shareable'] ?? false,
      isInternal: json['is_internal'] ?? false,
      cardType: json['card_type']?.toString(),
      level: json['level'],
    );
  }
}
