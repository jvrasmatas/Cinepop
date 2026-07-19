class Cast {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  /// Creates a [Cast] from a decoded JSON map.
  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }
}
