class CardImage {
  final String imageUrl;
  final double? aspectRatio;

  CardImage({required this.imageUrl, this.aspectRatio});

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      imageUrl: json['image_url'],
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
    );
  }
}
