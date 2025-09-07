import 'package:flutter/material.dart';

import '../../../core/models/card_group.dart';
import 'hc1_small_display_card.dart';
import 'hc3_big_display_card.dart' as hc3;
import 'hc5_image_card.dart' as hc5;
import 'hc6_small_card_arrow.dart' as hc6;
import 'hc9_dynamic_width_card.dart' as hc9;

class CardContainer extends StatelessWidget {
  final List<CardGroup> groups;
  const CardContainer({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        switch (group.designType) {
          case "HC1":
            if (group.cards.isEmpty) {
              return const SizedBox.shrink();
            }
            if (group.isScrollable) {
              return SizedBox(
                height: group.height ?? 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: group.cards.length,
                  itemBuilder: (context, index) {
                    if (index >= group.cards.length) return const SizedBox.shrink();
                    return HC1SmallDisplayCard(
                      card: group.cards[index],
                      height: group.height ?? 80,
                    );
                  },
                ),
              );
            } else {
              return Column(
                children: group.cards
                    .map((card) => HC1SmallDisplayCard(card: card))
                    .toList(),
              );
            }

          case "HC3":
            if (group.cards.isEmpty) {
              return const SizedBox.shrink();
            }
            if (group.isScrollable) {
              return SizedBox(
                height: group.height ?? 600,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: group.cards.length,
                  itemBuilder: (context, index) {
                    if (index >= group.cards.length) return const SizedBox.shrink();
                    return hc3.HC3BigDisplayCard(card: group.cards[index]);
                  },
                ),
              );
            } else {
              return Column(
                children: group.cards
                    .map((card) => hc3.HC3BigDisplayCard(card: card))
                    .toList(),
              );
            }

          case "HC5":
            if (group.cards.isEmpty) {
              return const SizedBox.shrink();
            }
            if (group.isScrollable) {
              return SizedBox(
                height: group.height ?? 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: group.cards.length,
                  itemBuilder: (context, index) {
                    if (index >= group.cards.length) return const SizedBox.shrink();
                    return hc5.HC5ImageCard(
                      card: group.cards[index],
                      height: group.height ?? 200,
                    );
                  },
                ),
              );
            } else {
              return Column(
                children: group.cards
                    .map((card) => hc5.HC5ImageCard(
                      card: card,
                      height: group.height ?? 200,
                    ))
                    .toList(),
              );
            }

          case "HC6":
            if (group.cards.isEmpty) {
              return const SizedBox.shrink();
            }
            // Always use single card display for proper alignment
            return hc6.HC6SmallCardArrow(card: group.cards.first);

          case "HC9":
            if (group.cards.isEmpty) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              height: group.height ?? 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: group.cards.length,
                itemBuilder: (context, index) {
                  if (index >= group.cards.length) return const SizedBox.shrink();
                  return hc9.HC9DynamicWidthCard(
                    card: group.cards[index],
                    height: group.height ?? 140,
                  );
                },
              ),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}
