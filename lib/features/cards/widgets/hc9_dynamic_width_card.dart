import 'package:cached_network_image/cached_network_image.dart';
import 'package:fampay_assignment/core/models/card_model.dart';
import 'package:flutter/material.dart';

class HC9DynamicWidthCard extends StatelessWidget {
  final CardModel card;
  final double? height;

  const HC9DynamicWidthCard({super.key, required this.card, this.height});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isTablet = screenWidth > 600;

    // Calculate dynamic width based on aspect ratio
    final cardHeight = height ?? (isSmallScreen ? 100 : (isTablet ? 140 : 120));
    final aspectRatio = card.bgImage?.aspectRatio ?? 1.0;
    final dynamicWidth = cardHeight * aspectRatio;

    return Container(
      width: dynamicWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 0, // Remove vertical margin to eliminate space
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildBackground(),
      ),
    );
  }

  Widget _buildBackground() {
    // Check if we have both gradient and image
    if (card.bgGradient != null && card.bgImage?.imageUrl != null) {
      // Stack gradient and image
      return Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: card.bgGradient!.colors
                    .map((color) => Color(int.parse(color.replaceAll('#', '0xff'))))
                    .toList(),
                transform: GradientRotation(card.bgGradient!.angle * (3.14159 / 180)),
              ),
            ),
          ),
          // Image overlay
          CachedNetworkImage(
            imageUrl: card.bgImage!.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: card.bgGradient!.colors
                      .map((color) => Color(int.parse(color.replaceAll('#', '0xff'))))
                      .toList(),
                  transform: GradientRotation(card.bgGradient!.angle * (3.14159 / 180)),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: card.bgGradient!.colors
                      .map((color) => Color(int.parse(color.replaceAll('#', '0xff'))))
                      .toList(),
                  transform: GradientRotation(card.bgGradient!.angle * (3.14159 / 180)),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (card.bgGradient != null) {
      // Only gradient
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: card.bgGradient!.colors
                .map((color) => Color(int.parse(color.replaceAll('#', '0xff'))))
                .toList(),
            transform: GradientRotation(card.bgGradient!.angle * (3.14159 / 180)),
          ),
        ),
      );
    } else if (card.bgImage?.imageUrl != null) {
      // Only image
      return CachedNetworkImage(
        imageUrl: card.bgImage!.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
        ),
      );
    } else {
      // Fallback
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.image,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    }
  }
}
