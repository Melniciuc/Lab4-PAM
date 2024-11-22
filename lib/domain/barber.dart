class BarberInfo {
  final String name;
  final String location;
  final double rating;
  final String imagePath;

  BarberInfo({
    required this.name,
    required this.location,
    required this.rating,
    required this.imagePath,
  });

  factory BarberInfo.fromJson(Map<String, dynamic> json) {
    return BarberInfo(
      name: json['name'],
      location: json['location_with_distance'],
      rating: json['review_rate'].toDouble(),
      imagePath: json['image'],
    );
  }
}
