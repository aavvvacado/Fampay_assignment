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
      end: const Offset(0.2, 0),
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
    final isTablet = screenWidth > 600;

    return GestureDetector(
      onTap: _handleCardTap,
      onLongPress: _handleLongPress,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(
            left: _longPressed
                ? (isSmallScreen ? 60 : 80)
                : (isSmallScreen ? 12 : 16),
            right: isSmallScreen ? 12 : 16,
            top: isSmallScreen ? 6 : 8,
            bottom: isSmallScreen ? 6 : 8,
          ),
          height: isSmallScreen ? 400 : (isTablet ? 500 : 450),
          decoration: BoxDecoration(
            color: Colors.indigo[800],
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
                 // Background Image
                 if (widget.card.bgImage?.imageSource != null)
                   Positioned.fill(
                     child: widget.card.bgImage!.imageType == 'asset'
                         ? Image.asset(
                             widget.card.bgImage!.imageSource!,
                             fit: BoxFit.cover,
                             errorBuilder: (context, error, stackTrace) =>
                                 Container(color: Colors.indigo[800]),
                           )
                         : CachedNetworkImage(
                             imageUrl: widget.card.bgImage!.imageSource!,
                             fit: BoxFit.cover,
                             placeholder: (context, url) => Container(
                               color: Colors.indigo[800],
                             ),
                             errorWidget: (context, url, error) => Container(
                               color: Colors.indigo[800],
                             ),
                           ),
                   ),

                // Background Color/Gradient fallback
                if (widget.card.bgImage?.imageSource == null)
                  Container(
                    decoration: BoxDecoration(
                      color: widget.card.bgColor != null
                          ? Color(int.parse(widget.card.bgColor!.replaceAll('#', '0xff')))
                          : Colors.indigo[800],
                      gradient: widget.card.bgGradient != null
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: widget.card.bgGradient!.colors
                                  .map((color) => Color(int.parse(color.replaceAll('#', '0xff'))))
                                  .toList(),
                              transform: GradientRotation(
                                (widget.card.bgGradient!.angle ?? 0) * (3.14159 / 180),
                              ),
                            )
                          : null,
                    ),
                  ),

                // Content
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                    child: Column(
                      children: [
                        // Title with formatted text - left aligned
                        if (widget.card.formattedTitle != null)
                          _buildFormattedText(widget.card.formattedTitle!,
                              isSmallScreen, isTablet)
                        else if (widget.card.title != null)
                          Text(
                            widget.card.title!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize:
                                  isSmallScreen ? 28 : (isTablet ? 36 : 32),
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[400],
                              height: 1.2,
                              decoration: TextDecoration.underline,
                            ),
                          ),

                        // Description - left aligned (only if not part of formatted_title)
                        if (widget.card.description != null &&
                            widget.card.formattedTitle == null)
                          Padding(
                            padding:
                                EdgeInsets.only(top: isSmallScreen ? 16 : 20),
                            child: Text(
                              widget.card.description!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize:
                                    isSmallScreen ? 16 : (isTablet ? 20 : 18),
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),

                        const Spacer(),

                        // CTA Button - centered at bottom
                        if (widget.card.cta != null &&
                            widget.card.cta!.isNotEmpty)
                          Center(
                            child: SizedBox(
                              width:
                                  isSmallScreen ? 180 : (isTablet ? 240 : 220),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (widget.card.cta!.first
                                                  as Map<String, dynamic>)[
                                              'bg_color'] !=
                                          null
                                      ? Color(int.parse((widget.card.cta!.first
                                                  as Map<String, dynamic>)[
                                              'bg_color']
                                          .replaceAll('#', '0xff')))
                                      : Colors.black,
                                  foregroundColor: (widget.card.cta!.first
                                                  as Map<String, dynamic>)[
                                              'text_color'] !=
                                          null
                                      ? Color(int.parse((widget.card.cta!.first
                                                  as Map<String, dynamic>)[
                                              'text_color']
                                          .replaceAll('#', '0xff')))
                                      : Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 14 : 18,
                                    horizontal: isSmallScreen ? 28 : 36,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      (widget.card.cta!.first as Map<String,
                                                  dynamic>)['is_circular'] ==
                                              true
                                          ? 50
                                          : 8,
                                    ),
                                  ),
                                ),
                                onPressed: _handleCtaTap,
                                child: Text(
                                  (widget.card.cta!.first
                                          as Map<String, dynamic>)['text'] ??
                                      'Action',
                                  style: TextStyle(
                                    fontSize: isSmallScreen
                                        ? 16
                                        : (isTablet ? 20 : 18),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Long press action buttons
                if (_longPressed)
                  Positioned(
                    left: isSmallScreen ? 8 : 12,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Remind Later button
                        Container(
                          width: isSmallScreen ? 60 : 70,
                          height: isSmallScreen ? 80 : 90,
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
                                  size: isSmallScreen ? 24 : 28,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'remind later',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 10 : 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        // Dismiss Now button
                        Container(
                          width: isSmallScreen ? 60 : 70,
                          height: isSmallScreen ? 80 : 90,
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
                                  size: isSmallScreen ? 24 : 28,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'dismiss now',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 10 : 12,
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
              ],
            ),
          ),
        ),
      ),
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
          color: Colors.amber[400],
          height: 1.2,
          decoration: TextDecoration.underline,
        ),
      );
    }

    return _parseFormattedText(formattedText, isSmallScreen, isTablet);
  }

  Widget _parseFormattedText(
      FormattedText formattedText, bool isSmallScreen, bool isTablet) {
    List<TextSpan> spans = [];
    List<dynamic> entities = formattedText.entities!;

    // Parse the text with placeholders and apply entity formatting
    for (var entity in entities) {
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
              ),
            ),
          );
        }
      }
    }

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: spans,
        style: TextStyle(
          fontSize: isSmallScreen ? 28 : (isTablet ? 36 : 32),
          fontWeight: FontWeight.bold,
          color: Colors.amber[400],
          height: 1.2,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
