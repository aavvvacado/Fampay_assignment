import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/card_model.dart';
import '../../../core/models/formatted_text.dart';
import '../../../core/services/url_launcher_service.dart';
import '../bloc/cards_bloc.dart';
import '../bloc/cards_event.dart';

class HC3BigDisplayCard extends StatefulWidget {
  final CardModel card;

  const HC3BigDisplayCard({super.key, required this.card});

  @override
  State<HC3BigDisplayCard> createState() => _HC3BigDisplayCardState();
}

class _HC3BigDisplayCardState extends State<HC3BigDisplayCard>
    with TickerProviderStateMixin {
  bool _longPressed = false;

  late AnimationController _slideController;

  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,

      end: const Offset(0.2, 0), // Reduced slide distance to stay within bounds
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();

    super.dispose();
  }

  void _handleLongPress() {
    setState(() {
      _longPressed = !_longPressed;
    });

    if (_longPressed) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  void _handleCardTap() {
    if (widget.card.url != null && widget.card.url!.isNotEmpty) {
      UrlLauncherService.launchURL(widget.card.url, context: context);
    }
  }

  void _handleCtaTap() {
    if (widget.card.cta != null && widget.card.cta!.isNotEmpty) {
      final ctaData = widget.card.cta!.first as Map<String, dynamic>;

      final ctaUrl = ctaData['url'];

      if (ctaUrl != null && ctaUrl.isNotEmpty) {
        UrlLauncherService.launchURL(ctaUrl, context: context);
      } else {
// Fallback to card URL if CTA doesn't have its own URL

        if (widget.card.url != null && widget.card.url!.isNotEmpty) {
          UrlLauncherService.launchURL(widget.card.url, context: context);
        }
      }
    }
  }

  void _handleRemindLater() {
    context.read<CardsBloc>().add(RemindLaterCardEvent(widget.card.id));

    _handleLongPress(); // Close the action panel
  }

  void _handleDismissNow() {
    context.read<CardsBloc>().add(DismissCardEvent(widget.card.id));

    _handleLongPress(); // Close the action panel
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isSmallScreen = screenWidth < 400;

    return Stack(
      children: [
// Long press action buttons - positioned behind the card on the left

        if (_longPressed)
          Positioned(
            left: 16,
            top: 8,
            bottom: 8,
            child: Container(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
// Remind Later button

                  Container(
                    width: 80,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: _handleRemindLater,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.amber[800],
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'remind\nlater',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

// Dismiss Now button

                  Container(
                    width: 80,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: _handleDismissNow,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
                            color: Colors.amber[800],
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'dismiss\nnow',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

// Main card with slide animation

        AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(
            left: _longPressed ? 80 : 14,
            right: 14,
            top: 7,
            bottom: 7,
          ),
          child: GestureDetector(
            onTap: _handleCardTap,
            onLongPress: _handleLongPress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 400,
              decoration: BoxDecoration(
                color:
                    const Color(0xFF454AA6), // Using the specified card color
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
// Background gradient if available

                    if (widget.card.bgGradient != null)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: widget.card.bgGradient!.colors
                                .map((color) => Color(
                                    int.parse(color.replaceAll('#', '0xff'))))
                                .toList(),
                            transform: GradientRotation(
                              (widget.card.bgGradient!.angle ?? 0) *
                                  (3.14159 / 180),
                            ),
                          ),
                        ),
                      ),

// Complete redesign with proper Figma-like layout

                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
// BIG Icon at top-left - very prominent

                          if (widget.card.bgImage?.imageUrl != null)
                            Container(
                              width: widget.card.bgImage?.width != null
                                  ? widget.card.bgImage!.width!
                                  : 150,
                              height: widget.card.bgImage?.height != null
                                  ? widget.card.bgImage!.height!
                                  : 150,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: widget.card.bgImage!.imageType == 'asset'
                                  ? Image.asset(
                                      widget.card.bgImage!.imageUrl!,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const SizedBox(),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.card.bgImage!.imageUrl!,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const SizedBox(),
                                      errorWidget: (context, url, error) =>
                                          const SizedBox(),
                                    ),
                            ),

                          if (widget.card.formattedTitle != null)
                            _buildFormattedText(widget.card.formattedTitle!,
                                isSmallScreen, false)
                          else if (widget.card.title != null)
                            Text(
                              widget.card.title!,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),

                          const SizedBox(height: 28),

// Description - clear and readable

                          if (widget.card.description != null &&
                              widget.card.formattedTitle == null)
                            Text(
                              widget.card.description!,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                          const Spacer(),

// Small left-aligned CTA Button

                          if (widget.card.cta != null &&
                              widget.card.cta!.isNotEmpty)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 160,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: (widget.card.cta!.first
                                                    as Map<String, dynamic>)[
                                                'bg_color'] !=
                                            null
                                        ? Color(int.parse(
                                            (widget.card.cta!.first as Map<
                                                    String,
                                                    dynamic>)['bg_color']
                                                .replaceAll('#', '0xff')))
                                        : Colors.black,
                                    foregroundColor: (widget.card.cta!.first
                                                    as Map<String, dynamic>)[
                                                'text_color'] !=
                                            null
                                        ? Color(int.parse(
                                            (widget.card.cta!.first as Map<
                                                    String,
                                                    dynamic>)['text_color']
                                                .replaceAll('#', '0xff')))
                                        : Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        (widget.card.cta!.first as Map<String,
                                                    dynamic>)['is_circular'] ==
                                                true
                                            ? 22
                                            : 8,
                                      ),
                                    ),
                                    elevation: 3,
                                    shadowColor: Colors.black.withOpacity(0.2),
                                  ),
                                  onPressed: _handleCtaTap,
                                  child: Text(
                                    (widget.card.cta!.first
                                            as Map<String, dynamic>)['text'] ??
                                        'Action',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormattedText(
      FormattedText formattedText, bool isSmallScreen, bool isTablet) {
    if (formattedText.entities == null || formattedText.entities!.isEmpty) {
      return Text(
        formattedText.text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: isSmallScreen ? 28 : (isTablet ? 36 : 32),
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
        ),
      );
    }

    return _parseFormattedText(formattedText, isSmallScreen, isTablet);
  }

  Widget _parseFormattedText(
      FormattedText formattedText, bool isSmallScreen, bool isTablet) {
    List<TextSpan> spans = [];

    List<dynamic> entities = formattedText.entities!;

// Parse entities and create text spans

    for (int i = 0; i < entities.length; i++) {
      var entity = entities[i];

      if (entity is Map<String, dynamic>) {
        String entityText = entity['text'] ?? '';

        String color = entity['color'] ?? '#ffffff';

        String? entityUrl = entity['url'];

        double fontSize = (entity['font_size'] as num?)?.toDouble() ??
            (isSmallScreen ? 24.0 : (isTablet ? 32.0 : 28.0));

        String fontStyle = entity['font_style'] ?? 'normal';

        String fontFamily = entity['font_family'] ?? '';

// Apply responsive scaling to API font sizes

        double responsiveFontSize = fontSize;

        if (isSmallScreen) {
          responsiveFontSize = fontSize * 0.9;
        } else if (isTablet) {
          responsiveFontSize = fontSize * 1.1;
        }

        FontWeight fontWeight = FontWeight.normal;

        TextDecoration decoration = TextDecoration.none;

        if (fontStyle.contains('bold')) {
          fontWeight = FontWeight.bold;
        }

        if (fontStyle.contains('underline')) {
          decoration = TextDecoration.underline;
        }

// Create clickable span if URL is provided

        if (entityUrl != null && entityUrl.isNotEmpty) {
          spans.add(
            TextSpan(
              text: entityText,
              style: TextStyle(
                color: Color(int.parse(color.replaceAll('#', '0xff'))),
                fontSize: responsiveFontSize,
                fontWeight: fontWeight,
                decoration: decoration,
                fontFamily: fontFamily.isNotEmpty ? fontFamily : null,
                height: 1.3,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  UrlLauncherService.launchURL(entityUrl, context: context);
                },
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: entityText,
              style: TextStyle(
                color: Color(int.parse(color.replaceAll('#', '0xff'))),
                fontSize: responsiveFontSize,
                fontWeight: fontWeight,
                decoration: decoration,
                fontFamily: fontFamily.isNotEmpty ? fontFamily : null,
                height: 1.3,
              ),
            ),
          );
        }

// Add line break if this is not the last entity

        if (i < entities.length - 1) {
          spans.add(const TextSpan(text: '\n'));
        }
      }
    }

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: spans,
        style: const TextStyle(
          height: 1.3,
        ),
      ),
    );
  }
}
