class CardImage {
  final String? imageUrl;
  final String? assetType;
  final String imageType;
  final double? aspectRatio;
  final double? width;
  final double? height;

  CardImage({
    this.imageUrl,
    this.assetType,
    required this.imageType,
    this.aspectRatio,
    this.width,
    this.height,
  });

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      imageUrl: json['image_url'],
      assetType: json['asset_type'],
      imageType: json['image_type'] ?? 'external',
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );
  }

  // Helper method to get the correct image source
  String? get imageSource {
    if (imageType == 'asset' && assetType != null) {
      return 'assets/$assetType';
    } else if (imageType == 'external' && imageUrl != null) {
      return imageUrl;
    }
    return null;
  }
}
