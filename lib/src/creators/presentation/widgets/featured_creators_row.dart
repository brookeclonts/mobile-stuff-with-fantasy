import 'package:flutter/material.dart';
import 'package:swf_app/src/creators/models/creator.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class FeaturedCreatorsRow extends StatelessWidget {
  const FeaturedCreatorsRow({
    super.key,
    required this.creators,
    required this.onCreatorTap,
  });

  final List<Creator> creators;
  final ValueChanged<Creator> onCreatorTap;

  @override
  Widget build(BuildContext context) {
    if (creators.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 88,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: creators.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final creator = creators[index];
          return _CreatorCircle(
            creator: creator,
            onTap: () => onCreatorTap(creator),
          );
        },
      ),
    );
  }
}

class _CreatorCircle extends StatelessWidget {
  const _CreatorCircle({required this.creator, required this.onTap});

  final Creator creator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ringColor =
        creator.role.isAuthor ? SwfColors.color6 : SwfColors.blueBright;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ring + avatar
            Container(
              width: 62,
              height: 62,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 2),
              ),
              child: CircleAvatar(
                backgroundColor: SwfColors.color5,
                backgroundImage: creator.imageUrl.isNotEmpty
                    ? NetworkImage(creator.imageUrl)
                    : null,
                child: creator.imageUrl.isEmpty
                    ? Text(
                        _initial(creator.name),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: SwfColors.color3,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            // Name
            Text(
              _firstName(creator.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: SwfColors.color8,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initial(String name) {
    if (name.isEmpty) return '?';
    return name.substring(0, 1).toUpperCase();
  }

  static String _firstName(String name) {
    if (name.isEmpty) return '';
    return name.split(' ').first;
  }
}
