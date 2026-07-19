import 'cast.dart';

class CreditsResponse {
  final int id;
  final List<Cast> cast;

  const CreditsResponse({required this.id, required this.cast});

  factory CreditsResponse.fromJson(Map<String, dynamic> json) {
    final castJson = json['cast'] as List<dynamic>? ?? [];

    return CreditsResponse(
      id: json['id'] as int? ?? 0,
      cast: castJson
          .map((c) => Cast.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
