class User {
  final String id;
  final String name;
  final String createdAt;
  final String avatar;

  User({this.id, this.name, this.createdAt, this.avatar});

  factory User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      return User(
          id: jsonMap['id'].toString(),
          name: jsonMap['description'] != null
              ? jsonMap['description'].toString()
              : null,
          createdAt: jsonMap['address'] != null ? jsonMap['address'] : null,
          avatar: jsonMap['latitude'] != null ? jsonMap['latitude'] : null);
    } catch (e) {
      return null;
    }
  }
}
