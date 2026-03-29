import 'package:flutter/material.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const _quillNames = <String>[
  '',
  'Faded Ink',
  'Common Script',
  'Fine Hand',
  "Master's Script",
  'Gilded Quill',
];

/// A fantasy-themed rating widget using quill icons.
///
/// Displays 1–5 quills filled left-to-right. Level 5 ("Gilded Quill")
/// renders all quills in gold. In [interactive] mode, each quill is
/// tappable and a level name label appears below.
class QuillRating extends StatelessWidget {
  const QuillRating({
    super.key,
    required this.rating,
    this.size = 20,
    this.interactive = false,
    this.onChanged,
    this.accentColor,
    this.showLabel = false,
  });

  final int rating;
  final double size;
  final bool interactive;
  final ValueChanged<int>? onChanged;
  final Color? accentColor;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? SwfColors.blue;
    final isGilded = rating == 5;
    final filledColor = isGilded ? SwfColors.secondaryAccent : accent;
    const emptyColor = Color(0xFF5C4F42);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            final level = i + 1;
            final filled = level <= rating;

            final icon = Icon(
              Icons.edit,
              size: size,
              color: filled ? filledColor : emptyColor.withAlpha(60),
            );

            if (!interactive) return icon;

            return _TappableQuill(
              icon: icon,
              onTap: () => onChanged?.call(level),
            );
          }),
        ),
        if (showLabel && rating > 0) ...[
          const SizedBox(height: 4),
          Text(
            _quillNames[rating].toUpperCase(),
            style: TextStyle(
              color: filledColor,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  /// Returns the fantasy name for a given rating level (1–5).
  static String nameForRating(int rating) {
    if (rating < 1 || rating > 5) return '';
    return _quillNames[rating];
  }
}

class _TappableQuill extends StatefulWidget {
  const _TappableQuill({required this.icon, required this.onTap});

  final Widget icon;
  final VoidCallback onTap;

  @override
  State<_TappableQuill> createState() => _TappableQuillState();
}

class _TappableQuillState extends State<_TappableQuill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: ScaleTransition(scale: _scale, child: widget.icon),
    );
  }
}
