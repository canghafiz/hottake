import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class PhotoProfileWidget extends StatelessWidget {
  const PhotoProfileWidget({
    Key? key,
    required this.url,
    required this.size,
    required this.theme,
  }) : super(key: key);
  final String? url;
  final double size;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url != null) {
          // Navigate
          toImageDetailPage(context: context, url: url!);
        }
      },
      child: CircleAvatar(
        backgroundImage:
            (url == null) ? null : CachedNetworkImageProvider(url!),
        child: (url == null)
            ? Icon(
                Icons.person,
                color: convertTheme(theme.secondary),
                size: size - (size * 1 / 8),
              )
            : null,
        minRadius: size,
        maxRadius: size,
        backgroundColor: convertTheme(theme.secondary).withOpacity(0.5),
      ),
    );
  }
}
