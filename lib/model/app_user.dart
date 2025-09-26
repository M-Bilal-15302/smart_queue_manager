class AppUser {
  final String id;
  final String email;
  final String name;
  final String phone;
  final bool isAdmin;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.isAdmin = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'isAdmin': isAdmin,
    };
  }
}
