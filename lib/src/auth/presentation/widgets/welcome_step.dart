import 'package:flutter/material.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Step 3: Welcome screen shown after successful sign-up.
class WelcomeStep extends StatefulWidget {
  const WelcomeStep({
    super.key,
    required this.name,
    required this.role,
    required this.onGetStarted,
  });

  final String name;
  final UserRole role;
  final VoidCallback onGetStarted;

  @override
  State<WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<WelcomeStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _subtitle =>
      'Your next great fantasy adventure is waiting for you.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: SwfColors.color4.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 48,
                color: SwfColors.color4,
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                Text(
                  'Welcome, ${widget.name}!',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
          FadeTransition(
            opacity: _fadeAnim,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onGetStarted,
                child: const Text('Get Started'),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
