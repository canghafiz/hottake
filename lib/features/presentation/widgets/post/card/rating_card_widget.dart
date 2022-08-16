import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class RatingCardWidget extends StatelessWidget {
  const RatingCardWidget({
    Key? key,
    required this.userId,
    required this.rating,
    required this.theme,
  }) : super(key: key);
  final String userId;
  final RatingEntity rating;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating | Value
        Row(
          children: [
            // Rating
            Flexible(
              child: RatingBar.builder(
                initialRating: rating.rating,
                minRating: 0,
                direction: Axis.horizontal,
                ignoreGestures: true,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemSize: 24,
                unratedColor: convertTheme(theme.third).withOpacity(0.3),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (_) {},
              ),
            ),
            const SizedBox(width: 8),
            // Value
            Text(
              rating.rating.toString(),
              style: fontStyle(
                size: 11,
                theme: theme,
                color: convertTheme(theme.third).withOpacity(0.5),
              ),
            ),
          ],
        ),
        // Description
        Text(
          '"${rating.description}"',
          style: fontStyle(
            size: 13,
            theme: theme,
            color: convertTheme(theme.third).withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
