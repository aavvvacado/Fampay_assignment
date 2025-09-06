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
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 6 : 8,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      height: isSmallScreen ? 50 : (isTablet ? 60 : 55),
      decoration: BoxDecoration(
        color: card.bgColor != null
            ? Color(int.parse(card.bgColor!.replaceAll('#', '0xff')))
            : Colors.orange[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon
          if (card.icon?.imageSource != null)
            Container(
              margin: EdgeInsets.only(right: isSmallScreen ? 12 : 16),
              child: card.icon!.imageType == 'asset'
                  ? Image.asset(
                      card.icon!.imageSource!,
                      height: card.iconSize ?? (isSmallScreen ? 16 : (isTablet ? 20 : 18)),
                      width: card.iconSize ?? (isSmallScreen ? 16 : (isTablet ? 20 : 18)),
                      fit: BoxFit.contain,
                    )
                  : CachedNetworkImage(
                      imageUrl: card.icon!.imageSource!,
                      height: card.iconSize ?? (isSmallScreen ? 16 : (isTablet ? 20 : 18)),
                      width: card.iconSize ?? (isSmallScreen ? 16 : (isTablet ? 20 : 18)),
                      fit: BoxFit.contain,
                    ),
            ),
          
          // Title with formatted text support
          Expanded(
            child: card.formattedTitle != null
                ? _buildFormattedText(card.formattedTitle!, isSmallScreen, isTablet)
                : Text(
                    card.title ?? "Small card",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : (isTablet ? 16 : 15),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          
          // Arrow icon
          Icon(
            Icons.arrow_forward_ios,
            size: isSmallScreen ? 16 : (isTablet ? 20 : 18),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(FormattedText formattedText, bool isSmallScreen, bool isTablet) {
    if (formattedText.entities == null || formattedText.entities!.isEmpty) {
      return Text(
        formattedText.text,
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : (isTablet ? 16 : 15),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
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
        double fontSize = (entity['font_size'] as num?)?.toDouble() ??
            (isSmallScreen ? 14.0 : (isTablet ? 16.0 : 15.0));
        String fontStyle = entity['font_style'] ?? 'normal';
        String fontFamily = entity['font_family'] ?? '';

        // Apply responsive scaling to API font sizes
        double responsiveFontSize = fontSize;
        if (isSmallScreen) {
          responsiveFontSize = fontSize * 0.8;
        } else if (isTablet) {
          responsiveFontSize = fontSize * 1.2;
        }

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
              fontSize: responsiveFontSize,
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
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : (isTablet ? 16 : 15),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}