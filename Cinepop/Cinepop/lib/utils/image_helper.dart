import '../config/constants.dart';

class ImageHelper {
  ImageHelper._();

  static String? posterUrl(String? path) =>
      _build(path, AppConstants.posterSize);

  static String? backdropUrl(String? path) =>
      _build(path, AppConstants.backdropSize);

  static String? profileUrl(String? path) =>
      _build(path, AppConstants.profileSize);

  static String? _build(String? path, String size) {
    if (path == null || path.isEmpty) return null;
    return '${AppConstants.imageBaseUrl}/$size$path';
  }
}
