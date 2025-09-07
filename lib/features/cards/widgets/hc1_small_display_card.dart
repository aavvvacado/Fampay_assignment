import 'package:cached_network_image/cached_network_image.dart';
import 'package:fampay_assignment/core/models/card_model.dart';
import 'package:flutter/material.dart';
import '../../../core/services/url_launcher_service.dart';

class HC1SmallDisplayCard extends StatelessWidget {
  final CardModel card;
  final double? height;
  const HC1SmallDisplayCard({super.key, required this.card, this.height});

  void _handleCardTap(BuildContext context) {
    UrlLauncherService.launchURL(card.url, context: context);
  }

  String _getDisplayTitle() {
    if (card.formattedTitle?.entities != null &&
        card.formattedTitle!.entities!.isNotEmpty) {
      for (var entity in card.formattedTitle!.entities!) {
        if (entity is Map<String, dynamic> && entity['text'] != null) {
          String text = entity['text'].toString().trim();
          if (text.isNotEmpty) {
            return text;
          }
        }
      }
    }
    if (card.title != null && card.title!.trim().isNotEmpty) {
      return card.title!.trim();
    }
    return "";
  }

  String _getDisplayDescription() {
    if (card.formattedDescription?.entities != null &&
        card.formattedDescription!.entities!.isNotEmpty) {
      for (var entity in card.formattedDescription!.entities!) {
        if (entity is Map<String, dynamic> && entity['text'] != null) {
          String text = entity['text'].toString().trim();
          if (text.isNotEmpty) {
            return text;
          }
        }
      }
    }
    if (card.description != null && card.description!.trim().isNotEmpty) {
      return card.description!.trim();
    }
    return "";
  }

  TextDecoration? _getTextDecoration() {
    if (card.formattedTitle?.entities != null &&
        card.formattedTitle!.entities!.isNotEmpty) {
      for (var entity in card.formattedTitle!.entities!) {
        if (entity is Map<String, dynamic> &&
            entity['font_style'] == 'underline') {
          return TextDecoration.underline;
        }
      }
    }
    if (card.formattedDescription?.entities != null &&
        card.formattedDescription!.entities!.isNotEmpty) {
      for (var entity in card.formattedDescription!.entities!) {
        if (entity is Map<String, dynamic> &&
            entity['font_style'] == 'underline') {
          return TextDecoration.underline;
        }
      }
    }
    return null;
  }

  String? _getFontFamily() {
    if (card.formattedTitle?.entities != null &&
        card.formattedTitle!.entities!.isNotEmpty) {
      for (var entity in card.formattedTitle!.entities!) {
        if (entity is Map<String, dynamic> && entity['font_family'] != null) {
          return entity['font_family'].toString();
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isTablet = screenWidth > 600;

    final isInHorizontalList = height != null;
    final textDecoration = _getTextDecoration();
    final fontFamily = _getFontFamily();

    return GestureDetector(
      onTap: () => _handleCardTap(context),
      child: Container(
        width: isInHorizontalList
            ? (isSmallScreen ? 200 : (isTablet ? 280 : 240))
            : null,
        height: height ?? 70,
        margin: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
        decoration: BoxDecoration(
          color: card.bgColor != null
              ? Color(int.parse(card.bgColor!.replaceAll('#', '0xff')))
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Image/Icon
            Container(
              width: isSmallScreen ? 24 : (isTablet ? 32 : 28),
              height: isSmallScreen ? 24 : (isTablet ? 32 : 28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: card.icon?.imageSource != null
                  ? ClipOval(
                      child: card.icon!.imageType == 'asset'
                          ? Image.asset(
                              card.icon!.imageSource!,
                              width: isSmallScreen ? 24 : (isTablet ? 32 : 28),
                              height: isSmallScreen ? 24 : (isTablet ? 32 : 28),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.white.withOpacity(0.2),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size:
                                      isSmallScreen ? 16 : (isTablet ? 20 : 18),
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: card.icon!.imageSource!,
                              width: isSmallScreen ? 24 : (isTablet ? 32 : 28),
                              height: isSmallScreen ? 24 : (isTablet ? 32 : 28),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.white.withOpacity(0.2),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size:
                                      isSmallScreen ? 16 : (isTablet ? 20 : 18),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.white.withOpacity(0.2),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size:
                                      isSmallScreen ? 16 : (isTablet ? 20 : 18),
                                ),
                              ),
                            ),
                    )
                  : Icon(
                      Icons.person,
                      color: Colors.white,
                      size: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                    ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    _getDisplayTitle(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 11 : (isTablet ? 15 : 13),
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      decoration: textDecoration,
                      fontFamily: fontFamily,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  // Description/Subtitle
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      _getDisplayDescription(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isSmallScreen ? 9 : (isTablet ? 13 : 11),
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        decoration: textDecoration,
                        fontFamily: fontFamily,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
