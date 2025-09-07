import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/card_model.dart';
import '../../../core/models/formatted_text.dart';

class HC6SmallCardArrow extends StatelessWidget {
  final CardModel card;

  const HC6SmallCardArrow({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(20), // Same padding as other cards
      height: 70, // Increased height
      decoration: BoxDecoration(
        color: card.bgColor != null
            ? Color(int.parse(card.bgColor!.replaceAll('#', '0xff')))
            : Colors.orange[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon - positioned to the left of text
          if (card.icon?.imageUrl != null)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: card.icon!.imageType == 'asset'
                  ? Image.asset(
                      card.icon!.imageUrl!,
                      height: card.iconSize ?? 20,
                      width: card.iconSize ?? 20,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    )
                  : CachedNetworkImage(
                      imageUrl: card.icon!.imageUrl!,
                      height: card.iconSize ?? 20,
                      width: card.iconSize ?? 20,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SizedBox(),
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
            ),

          // Scrollable text area expands to take remaining space
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: card.formattedTitle != null
                  ? _buildFormattedText(card.formattedTitle!, isSmallScreen, false)
                  : Text(
                      card.title ?? "Small card",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.visible,
                    ),
            ),
          ),

          const SizedBox(width: 8),

          // Arrow icon - pinned to the far right
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(FormattedText formattedText, bool isSmallScreen, bool isTablet) {
    if (formattedText.entities == null || formattedText.entities!.isEmpty) {
      return Text(
        formattedText.text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        overflow: TextOverflow.visible,
      );
    }

    return _parseFormattedText(formattedText, isSmallScreen, isTablet);
  }

  Widget _parseFormattedText(FormattedText formattedText, bool isSmallScreen, bool isTablet) {
    List<TextSpan> spans = [];
    List<dynamic> entities = formattedText.entities!;

    // Parse the text with placeholders and apply entity formatting
    for (var entity in entities) {
      if (entity is Map<String, dynamic>) {
        String entityText = entity['text'] ?? '';
        String color = entity['color'] ?? '#ffffff';
        double fontSize = (entity['font_size'] as num?)?.toDouble() ?? 15.0;
        String fontStyle = entity['font_style'] ?? 'normal';
        String fontFamily = entity['font_family'] ?? '';

        FontWeight fontWeight = FontWeight.normal;
        TextDecoration decoration = TextDecoration.none;

        if (fontStyle.contains('bold')) {
          fontWeight = FontWeight.bold;
        }
        if (fontStyle.contains('underline')) {
          decoration = TextDecoration.underline;
        }

        spans.add(
          TextSpan(
            text: entityText,
            style: TextStyle(
              color: Color(int.parse(color.replaceAll('#', '0xff'))),
              fontSize: fontSize,
              fontWeight: fontWeight,
              decoration: decoration,
              fontFamily: fontFamily.isNotEmpty ? fontFamily : null,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      overflow: TextOverflow.visible,
    );
  }
}