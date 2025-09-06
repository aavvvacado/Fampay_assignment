import 'card_group.dart';

class ApiResponse {
  final List<CardGroup> hcGroups;

  ApiResponse({required this.hcGroups});

  /// Accepts either a Map payload with key `hc_groups` or a top-level List
  factory ApiResponse.fromJson(dynamic json) {
    if (json is List) {
      // API returned a top-level list; each item may contain its own `hc_groups`
      final List<CardGroup> aggregatedGroups = [];
      for (final dynamic item in json) {
        if (item is Map<String, dynamic>) {
          final dynamic groups = item['hc_groups'];
          if (groups is List) {
            aggregatedGroups.addAll(groups
                .whereType<Map<String, dynamic>>()
                .map(CardGroup.fromJson));
          } else {
            // If item itself looks like a group, try parsing it directly
            aggregatedGroups.add(CardGroup.fromJson(item));
          }
        }
      }
      return ApiResponse(hcGroups: aggregatedGroups);
    }

    if (json is Map<String, dynamic>) {
      final dynamic groups = json['hc_groups'];
      if (groups is List) {
        return ApiResponse(
          hcGroups: groups
              .map((e) => CardGroup.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
    }

    // Fallback to empty list if structure is unexpected
    return ApiResponse(hcGroups: const []);
  }
}
