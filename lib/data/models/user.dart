class MyAppUser {
  final String? email;
  final String id;
  final String? name;
  final String? photo;

  const MyAppUser({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });
}
