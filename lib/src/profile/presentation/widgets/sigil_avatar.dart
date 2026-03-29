import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/data/sigil_compendium.dart';
import 'package:swf_app/src/profile/models/sigil_config.dart';
import 'package:swf_app/src/profile/models/sigil_part.dart';

/// Renders a composed heraldic sigil from a [SigilConfig].
///
/// The sigil is built from 4 layers: shield shape (clip), field fill,
/// central charge icon, and decorative border. Falls back to [initials]
/// in a plain circle when [config] is `null`.
class SigilAvatar extends StatelessWidget {
  const SigilAvatar({
    super.key,
    this.config,
    required this.accentColor,
    this.size = 48,
    this.initials = '?',
  });

  /// The sigil configuration, or `null` for the initials fallback.
  final SigilConfig? config;

  /// Accent color used for tinting the sigil layers.
  final Color accentColor;

  /// Diameter of the avatar.
  final double size;

  /// Fallback initials shown when [config] is `null`.
  final String initials;

  @override
  Widget build(BuildContext context) {
    final cfg = config;
    if (cfg == null) return _InitialsFallback(this);

    final charge = partById(cfg.chargeId);
    final border = partById(cfg.borderId);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: Shield shape + field fill
          _ShieldLayer(
            shieldId: cfg.shieldId,
            fieldId: cfg.fieldId,
            accentColor: accentColor,
            size: size,
          ),
          // Layer 2: Charge (central icon)
          if (charge != null)
            Icon(
              charge.icon,
              size: size * 0.42,
              color: _chargeColor(cfg.fieldId),
            ),
          // Layer 3: Border decoration
          if (border != null && border.id != 'border-plain')
            _BorderOverlay(
              borderPart: border,
              accentColor: accentColor,
              size: size,
              shieldId: cfg.shieldId,
            ),
        ],
      ),
    );
  }

  /// The charge icon color depends on the field to ensure contrast.
  Color _chargeColor(String fieldId) {
    // On solid/split accent backgrounds, use white. On gradient, slightly off-white.
    return Colors.white.withAlpha(230);
  }
}

// ---------------------------------------------------------------------------
// Fallback
// ---------------------------------------------------------------------------

class _InitialsFallback extends StatelessWidget {
  const _InitialsFallback(this.avatar);

  final SigilAvatar avatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: avatar.size,
      height: avatar.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatar.accentColor.withAlpha(20),
        border: Border.all(
          color: avatar.accentColor.withAlpha(80),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          avatar.initials,
          style: theme.textTheme.titleMedium?.copyWith(
            color: avatar.accentColor,
            fontWeight: FontWeight.w700,
            fontSize: avatar.size * 0.32,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shield layer (shape + fill)
// ---------------------------------------------------------------------------

class _ShieldLayer extends StatelessWidget {
  const _ShieldLayer({
    required this.shieldId,
    required this.fieldId,
    required this.accentColor,
    required this.size,
  });

  final String shieldId;
  final String fieldId;
  final Color accentColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        shape: _shapeForShield(shieldId),
        color: fieldId == 'field-gradient' ? null : accentColor.withAlpha(40),
        gradient: fieldId == 'field-gradient'
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withAlpha(60),
                  accentColor.withAlpha(25),
                ],
              )
            : fieldId == 'field-split'
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.5, 0.5],
                    colors: [
                      accentColor.withAlpha(50),
                      accentColor.withAlpha(20),
                    ],
                  )
                : null,
      ),
    );
  }

  ShapeBorder _shapeForShield(String id) {
    switch (id) {
      case 'shield-circle':
        return CircleBorder(
          side: BorderSide(color: accentColor.withAlpha(80), width: 1.5),
        );
      case 'shield-diamond':
        return _RotatedBorder(
          child: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: accentColor.withAlpha(80), width: 1.5),
          ),
        );
      case 'shield-hexagon':
        return _HexagonBorder(color: accentColor.withAlpha(80));
      case 'shield-star':
        return StarBorder(
          side: BorderSide(color: accentColor.withAlpha(80), width: 1.5),
          points: 5,
          innerRadiusRatio: 0.5,
        );
      case 'shield-heater':
      default:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * 0.2),
          side: BorderSide(color: accentColor.withAlpha(80), width: 1.5),
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Border overlay
// ---------------------------------------------------------------------------

class _BorderOverlay extends StatelessWidget {
  const _BorderOverlay({
    required this.borderPart,
    required this.accentColor,
    required this.size,
    required this.shieldId,
  });

  final SigilPart borderPart;
  final Color accentColor;
  final double size;
  final String shieldId;

  @override
  Widget build(BuildContext context) {
    // Render the border icon at the corners/edges as subtle decoration.
    final iconSize = size * 0.18;
    final offset = size * 0.02;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Top-right corner accent
          Positioned(
            top: offset,
            right: offset,
            child: Icon(
              borderPart.icon,
              size: iconSize,
              color: accentColor.withAlpha(100),
            ),
          ),
          // Bottom-left corner accent
          Positioned(
            bottom: offset,
            left: offset,
            child: Icon(
              borderPart.icon,
              size: iconSize,
              color: accentColor.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom shape borders
// ---------------------------------------------------------------------------

/// A rotated-45° rectangle (diamond shape).
class _RotatedBorder extends ShapeBorder {
  const _RotatedBorder({required this.child});

  final ShapeBorder child;

  @override
  EdgeInsetsGeometry get dimensions => child.dimensions;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _rotated(rect, child.getInnerPath(rect, textDirection: textDirection));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _rotated(rect, child.getOuterPath(rect, textDirection: textDirection));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.save();
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.rotate(0.7854); // 45 degrees
    canvas.translate(-rect.center.dx, -rect.center.dy);
    // Scale down to fit within the original bounds
    final scale = 0.72;
    canvas.translate(
      rect.center.dx * (1 - scale),
      rect.center.dy * (1 - scale),
    );
    canvas.scale(scale);
    child.paint(canvas, rect, textDirection: textDirection);
    canvas.restore();
  }

  Path _rotated(Rect rect, Path path) {
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    // ignore: deprecated_member_use
    final matrix = Matrix4.identity()
      ..translate(cx, cy) // ignore: deprecated_member_use
      ..rotateZ(0.7854)
      ..scale(0.72) // ignore: deprecated_member_use
      ..translate(-cx, -cy); // ignore: deprecated_member_use
    return path.transform(matrix.storage);
  }

  @override
  ShapeBorder scale(double t) => _RotatedBorder(child: child.scale(t));
}

/// A simple hexagon shape border.
class _HexagonBorder extends ShapeBorder {
  const _HexagonBorder({required this.color});

  final Color color;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _hexPath(rect.deflate(1.5));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _hexPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(_hexPath(rect), paint);
  }

  Path _hexPath(Rect rect) {
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final r = rect.shortestSide / 2;
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  ShapeBorder scale(double t) => this;
}
