import 'package:flutter/material.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/auth/presentation/widgets/interest_step.dart';
import 'package:swf_app/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:swf_app/src/auth/presentation/widgets/welcome_step.dart';
import 'package:swf_app/src/catalog/presentation/catalog_page.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Full-screen, 3-step sign-up flow.
///
///  1. Enter name, email, password (everyone signs up as a reader)
///  2. Optional interest capture (author / influencer)
///  3. Personalised welcome
///
/// Uses a [PageView] with programmatic navigation for smooth transitions.
class SignUpFlow extends StatefulWidget {
  const SignUpFlow({super.key});

  @override
  State<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends State<SignUpFlow> {
  static const _totalSteps = 3;
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1 state
  bool _isLoading = false;
  String? _errorMessage;
  String _signedUpName = '';

  // Step 2 state
  final Set<String> _interests = <String>{};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = step);
  }

  Future<void> _onFormSubmit(
    String name,
    String email,
    String password,
  ) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ServiceLocator.authRepository.signUp(
      name: name,
      email: email,
      password: password,
      role: UserRole.reader,
    );

    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {
          _isLoading = false;
          _signedUpName = name;
        });
        _goToStep(1);
      },
      failure: (message, _) {
        setState(() {
          _isLoading = false;
          _errorMessage = message;
        });
      },
    );
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_interests.contains(interest)) {
        _interests.remove(interest);
      } else {
        _interests.add(interest);
      }
    });
  }

  void _onInterestContinue() {
    // TODO: send _interests to backend when endpoint exists
    _goToStep(2);
  }

  void _onGetStarted() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const CatalogPage()),
      (_) => false,
    );
  }

  void _skipToCatalog() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const CatalogPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: back button, step dots, skip ──
            _TopBar(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _currentStep == 1 ? () => _goToStep(0) : null,
              onSkip: _currentStep < 2 ? _skipToCatalog : null,
            ),
            // ── Pages ──
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SignUpForm(
                    onSubmit: _onFormSubmit,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                  ),
                  InterestStep(
                    selectedInterests: _interests,
                    onToggle: _toggleInterest,
                    onContinue: _onInterestContinue,
                  ),
                  WelcomeStep(
                    name: _signedUpName,
                    role: UserRole.reader,
                    onGetStarted: _onGetStarted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top bar with back, step indicator, and skip
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.onSkip,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button (or empty space)
          SizedBox(
            width: 48,
            child: onBack != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: onBack,
                  )
                : null,
          ),
          const Spacer(),
          // Step dots
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalSteps, (i) {
              final isActive = i <= currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: i == currentStep ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isActive ? SwfColors.color4 : SwfColors.color5,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          // Skip button
          SizedBox(
            width: 48,
            child: onSkip != null
                ? TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(48, 36),
                    ),
                    onPressed: onSkip,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
