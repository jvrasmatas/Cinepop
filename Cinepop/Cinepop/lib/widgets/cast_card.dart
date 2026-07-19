import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/cast.dart';
import '../themes/colors.dart';
import '../utils/image_helper.dart';

class CastCard extends StatelessWidget {
  final Cast cast;

  const CastCard({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    final profileUrl = ImageHelper.profileUrl(cast.profilePath);

    return SizedBox(
      width: 90,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.surface,
            backgroundImage: profileUrl != null
                ? CachedNetworkImageProvider(profileUrl)
                : null,
            child: profileUrl == null
                ? const Icon(Icons.person, color: AppColors.muted, size: 36)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            cast.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            cast.character,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
