import 'package:cached_network_image/cached_network_image.dart';
import 'package:fampay_assignment/core/models/card_model.dart';
import 'package:flutter/material.dart';

class HC5ImageCard extends StatelessWidget {
  final CardModel card;
  const HC5ImageCard({super.key, required this.card});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card.bgImage?.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: card.bgImage!.imageUrl!,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          if (card.title != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                card.title!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          if (card.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(card.description!),
            ),
        ],
      ),
    );
  }
}
