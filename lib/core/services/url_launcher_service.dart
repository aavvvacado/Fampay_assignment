import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class UrlLauncherService {
  static Future<void> launchURL(String? url, {BuildContext? context}) async {
    if (url == null || url.isEmpty) {
      _showSnackBar(context, 'No URL available');
      return;
    }

    try {
      final Uri uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context != null && context.mounted) {
          _showSnackBar(context, 'Could not launch URL: $url');
        }
      }
    } catch (e) {
      if (context != null && context.mounted) {
        _showSnackBar(context, 'Error launching URL: $e');
      }
    }
  }

  static void _showSnackBar(BuildContext? context, String message) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
