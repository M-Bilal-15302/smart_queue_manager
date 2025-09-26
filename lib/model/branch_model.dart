class Branch {
  final String id;
  final String name;
  final String address;
  final String phone;
  final List<String> services;
  final String openingHours;
  final double latitude;
  final double longitude;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.services,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
  });

  factory Branch.fromMap(Map<String, dynamic> data, String id) {
    return Branch(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      services: List<String>.from(data['services'] ?? []),
      openingHours: data['openingHours'] ?? '9:00 AM - 5:00 PM',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'services': services,
      'openingHours': openingHours,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}