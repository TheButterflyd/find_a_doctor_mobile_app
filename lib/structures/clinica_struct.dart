class Clinica {
  final String id;
  final String name;
  final String city;
  final String imageUrl;

  Clinica({
    required this.id,
    required this.name,
    required this.city,
    required this.imageUrl,
  });

  factory Clinica.fromMap(Map<String, dynamic> data, String documentId) {
    return Clinica(
      id: documentId,
      name: data['name'] ?? '',
      city: data['city'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
