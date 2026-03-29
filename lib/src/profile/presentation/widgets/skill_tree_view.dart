import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/skill_tree.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Displays a visual skill tree with branching genre paths.
///
/// Uses a [CustomPainter] to draw the tree on a canvas, wrapped in an
/// [InteractiveViewer] for pan/zoom. Each branch is a vertical column
/// of tier nodes connected by lines fanning out from a central root.
class SkillTreeView extends StatefulWidget {
  const SkillTreeView({
    super.key,
    required this.skillTree,
    required this.accentColor,
    this.onTierTapped,
  });

  final SkillTree skillTree;
  final Color accentColor;
  final void Function(String branchId, String tierId)? onTierTapped;

  @override
  State<SkillTreeView> createState() => _SkillTreeViewState();
}

class _SkillTreeViewState extends State<SkillTreeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branches = widget.skillTree.branches;
    if (branches.isEmpty) return const SizedBox.shrink();

    // Layout dimensions
    const branchSpacing = 80.0;
    const tierSpacing = 72.0;
    const nodeRadius = 22.0;
    const rootY = 40.0;
    const branchStartY = rootY + 60.0;
    const headerHeight = 28.0;

    final maxTiers =
        branches.fold<int>(0, (m, b) => math.max(m, b.tiers.length));
    final canvasWidth = branches.length * branchSpacing + 40;
    final canvasHeight =
        branchStartY + headerHeight + maxTiers * tierSpacing + 40;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: math.max(canvasHeight, 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withAlpha(6),
            border: Border.all(color: Colors.white.withAlpha(20)),
          ),
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 0.8,
            maxScale: 2.0,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(40),
            child: GestureDetector(
              onTapUp: (details) => _handleTap(
                details.localPosition,
                branches,
                branchSpacing,
                tierSpacing,
                nodeRadius,
                branchStartY,
                headerHeight,
                canvasWidth,
              ),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size(canvasWidth, canvasHeight),
                    painter: _SkillTreePainter(
                      branches: branches,
                      accentColor: widget.accentColor,
                      branchSpacing: branchSpacing,
                      tierSpacing: tierSpacing,
                      nodeRadius: nodeRadius,
                      rootY: rootY,
                      branchStartY: branchStartY,
                      headerHeight: headerHeight,
                      pulseValue: _pulseController.value,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(
    Offset localPosition,
    List<SkillBranch> branches,
    double branchSpacing,
    double tierSpacing,
    double nodeRadius,
    double branchStartY,
    double headerHeight,
    double canvasWidth,
  ) {
    // Transform tap through the InteractiveViewer matrix
    final matrix = _transformController.value;
    final inverseMatrix = Matrix4.inverted(matrix);
    final transformed = MatrixUtils.transformPoint(inverseMatrix, localPosition);

    final totalWidth = branches.length * branchSpacing;
    final startX = (canvasWidth - totalWidth) / 2 + branchSpacing / 2;

    for (int b = 0; b < branches.length; b++) {
      final branch = branches[b];
      final bx = startX + b * branchSpacing;

      for (int t = 0; t < branch.tiers.length; t++) {
        final ty = branchStartY + headerHeight + t * tierSpacing + tierSpacing / 2;
        final distance = (transformed - Offset(bx, ty)).distance;

        if (distance <= nodeRadius + 8) {
          widget.onTierTapped?.call(branch.id, branch.tiers[t].id);
          return;
        }
      }
    }
  }
}

class _SkillTreePainter extends CustomPainter {
  _SkillTreePainter({
    required this.branches,
    required this.accentColor,
    required this.branchSpacing,
    required this.tierSpacing,
    required this.nodeRadius,
    required this.rootY,
    required this.branchStartY,
    required this.headerHeight,
    required this.pulseValue,
  });

  final List<SkillBranch> branches;
  final Color accentColor;
  final double branchSpacing;
  final double tierSpacing;
  final double nodeRadius;
  final double rootY;
  final double branchStartY;
  final double headerHeight;
  final double pulseValue;

  // Branch-specific accent colors for visual variety
  static const _branchColors = <Color>[
    SwfColors.blue,           // Epic Fantasy
    SwfColors.primaryButton,  // Romantasy
    SwfColors.violet,         // Dark Fantasy
    SwfColors.orange,         // Urban Fantasy
    SwfColors.secondaryAccent, // Mythic Fantasy
  ];

  Color _colorForBranch(int index) {
    return _branchColors[index % _branchColors.length];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalWidth = branches.length * branchSpacing;
    final startX = (size.width - totalWidth) / 2 + branchSpacing / 2;

    // ── Draw root node ──
    final rootCenter = Offset(size.width / 2, rootY);
    _drawRootNode(canvas, rootCenter);

    // ── Draw branches ──
    for (int b = 0; b < branches.length; b++) {
      final branch = branches[b];
      final bx = startX + b * branchSpacing;
      final branchColor = _colorForBranch(b);

      // Connector from root to branch header
      final branchTopY = branchStartY;
      _drawConnectorLine(
        canvas,
        rootCenter,
        Offset(bx, branchTopY),
        branch.tiers.isNotEmpty && branch.tiers.first.isUnlocked
            ? branchColor
            : branchColor.withAlpha(50),
        branch.tiers.isNotEmpty && branch.tiers.first.isUnlocked,
      );

      // ── Branch header icon ──
      _drawBranchIcon(canvas, Offset(bx, branchTopY), branch, branchColor);

      // ── Draw tier nodes ──
      for (int t = 0; t < branch.tiers.length; t++) {
        final tier = branch.tiers[t];
        final ty = branchStartY + headerHeight + t * tierSpacing + tierSpacing / 2;
        final center = Offset(bx, ty);

        // Connector line between tiers
        if (t == 0) {
          // From header to first tier
          _drawTierConnector(
            canvas,
            Offset(bx, branchTopY + 14),
            center,
            branchColor,
            tier.isUnlocked,
            branch.currentXp,
            tier.xpRequired,
          );
        } else {
          final prevTy = branchStartY + headerHeight + (t - 1) * tierSpacing + tierSpacing / 2;
          _drawTierConnector(
            canvas,
            Offset(bx, prevTy),
            center,
            branchColor,
            tier.isUnlocked,
            branch.currentXp,
            tier.xpRequired,
          );
        }

        // Determine node state
        final isCurrent = !tier.isUnlocked &&
            (t == 0 || branch.tiers[t - 1].isUnlocked);

        if (tier.isUnlocked) {
          _drawUnlockedNode(canvas, center, branchColor);
        } else if (isCurrent) {
          _drawCurrentNode(canvas, center, branchColor, branch.currentXp,
              tier.xpRequired);
        } else {
          _drawLockedNode(canvas, center, branchColor);
        }

        // Level number
        _drawLevelNumber(canvas, center, tier.level, tier.isUnlocked,
            isCurrent, branchColor);
      }
    }
  }

  void _drawRootNode(Canvas canvas, Offset center) {
    // Outer glow
    canvas.drawCircle(
      center,
      nodeRadius + 4,
      Paint()
        ..color = SwfColors.secondaryAccent.withAlpha(30 + (pulseValue * 20).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Fill
    canvas.drawCircle(
      center,
      nodeRadius,
      Paint()..color = SwfColors.secondaryAccent.withAlpha(40),
    );

    // Border
    canvas.drawCircle(
      center,
      nodeRadius,
      Paint()
        ..color = SwfColors.secondaryAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Center star icon placeholder (a small diamond)
    final path = Path()
      ..moveTo(center.dx, center.dy - 8)
      ..lineTo(center.dx + 6, center.dy)
      ..lineTo(center.dx, center.dy + 8)
      ..lineTo(center.dx - 6, center.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = SwfColors.secondaryAccent);
  }

  void _drawBranchIcon(
      Canvas canvas, Offset center, SkillBranch branch, Color color) {
    // Small indicator circle for the branch header
    canvas.drawCircle(
      center,
      12,
      Paint()..color = color.withAlpha(30),
    );
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = color.withAlpha(120)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawConnectorLine(
      Canvas canvas, Offset from, Offset to, Color color, bool isSolid) {
    if (isSolid) {
      canvas.drawLine(
        from,
        to,
        Paint()
          ..color = color.withAlpha(120)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    } else {
      _drawDashedLine(canvas, from, to, color.withAlpha(50), 2);
    }
  }

  void _drawTierConnector(
    Canvas canvas,
    Offset from,
    Offset to,
    Color color,
    bool isUnlocked,
    int currentXp,
    int requiredXp,
  ) {
    if (isUnlocked) {
      // Solid line for completed segment
      canvas.drawLine(
        from,
        to,
        Paint()
          ..color = color.withAlpha(150)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    } else {
      // Dashed line for locked segment
      _drawDashedLine(canvas, from, to, color.withAlpha(40), 2);

      // XP progress fill as partial solid line
      if (currentXp > 0 && requiredXp > 0) {
        final progress = (currentXp / requiredXp).clamp(0.0, 1.0);
        if (progress > 0) {
          final progressTo = Offset(
            from.dx + (to.dx - from.dx) * progress,
            from.dy + (to.dy - from.dy) * progress,
          );
          canvas.drawLine(
            from,
            progressTo,
            Paint()
              ..color = color.withAlpha(100)
              ..strokeWidth = 2.5
              ..strokeCap = StrokeCap.round,
          );
        }
      }
    }
  }

  void _drawDashedLine(
      Canvas canvas, Offset from, Offset to, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    const dashLength = 5.0;
    const gapLength = 4.0;

    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final unitX = dx / distance;
    final unitY = dy / distance;

    var drawn = 0.0;
    while (drawn < distance) {
      final start = Offset(
        from.dx + unitX * drawn,
        from.dy + unitY * drawn,
      );
      final end = Offset(
        from.dx + unitX * math.min(drawn + dashLength, distance),
        from.dy + unitY * math.min(drawn + dashLength, distance),
      );
      canvas.drawLine(start, end, paint);
      drawn += dashLength + gapLength;
    }
  }

  void _drawUnlockedNode(Canvas canvas, Offset center, Color color) {
    // Glow
    canvas.drawCircle(
      center,
      nodeRadius + 3,
      Paint()
        ..color = color.withAlpha(35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Fill
    canvas.drawCircle(center, nodeRadius, Paint()..color = color);

    // Border
    canvas.drawCircle(
      center,
      nodeRadius,
      Paint()
        ..color = SwfColors.secondaryAccent.withAlpha(120)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Checkmark
    final checkPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(center.dx - 6, center.dy)
      ..lineTo(center.dx - 2, center.dy + 5)
      ..lineTo(center.dx + 7, center.dy - 5);
    canvas.drawPath(path, checkPaint);
  }

  void _drawCurrentNode(Canvas canvas, Offset center, Color color,
      int currentXp, int requiredXp) {
    final pulseExtra = pulseValue * 4;

    // Pulsing glow
    canvas.drawCircle(
      center,
      nodeRadius + 4 + pulseExtra,
      Paint()
        ..color = color.withAlpha(20 + (pulseValue * 30).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Background fill
    canvas.drawCircle(
      center,
      nodeRadius,
      Paint()..color = color.withAlpha(25),
    );

    // Progress arc
    final progress = requiredXp > 0
        ? (currentXp / requiredXp).clamp(0.0, 1.0)
        : 0.0;

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: nodeRadius);
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Dashed outline for remaining
    _drawDashedCircle(canvas, center, nodeRadius, color.withAlpha(80), 2);

    // Inner dot
    canvas.drawCircle(
      center,
      5,
      Paint()..color = color,
    );
  }

  void _drawLockedNode(Canvas canvas, Offset center, Color color) {
    // Dim fill
    canvas.drawCircle(
      center,
      nodeRadius,
      Paint()..color = Colors.white.withAlpha(8),
    );

    // Dashed outline
    _drawDashedCircle(canvas, center, nodeRadius, color.withAlpha(40), 1.5);

    // Lock icon (simplified)
    final lockColor = color.withAlpha(60);
    // Lock body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center.translate(0, 2), width: 10, height: 8),
        const Radius.circular(2),
      ),
      Paint()..color = lockColor,
    );
    // Lock shackle
    canvas.drawArc(
      Rect.fromCenter(center: center.translate(0, -2), width: 8, height: 8),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = lockColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawDashedCircle(
      Canvas canvas, Offset center, double radius, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    const dashAngle = 0.2;
    const gapAngle = 0.15;
    var angle = 0.0;

    while (angle < 2 * math.pi) {
      final endAngle = math.min(angle + dashAngle, 2 * math.pi);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        angle,
        endAngle - angle,
        false,
        paint,
      );
      angle += dashAngle + gapAngle;
    }
  }

  void _drawLevelNumber(Canvas canvas, Offset center, int level,
      bool isUnlocked, bool isCurrent, Color color) {
    if (isUnlocked) return; // Checkmark is shown instead

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$level',
        style: TextStyle(
          color: isCurrent ? color : color.withAlpha(60),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy + nodeRadius + 4,
      ),
    );
  }

  @override
  bool shouldRepaint(_SkillTreePainter oldDelegate) =>
      pulseValue != oldDelegate.pulseValue ||
      branches != oldDelegate.branches ||
      accentColor != oldDelegate.accentColor;
}
