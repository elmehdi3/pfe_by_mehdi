import 'package:flutter/material.dart';
import 'onboarding_matchmaking_screen.dart';
import 'onboarding_chat_squads_screen.dart';
import 'onboarding_reputation_screen.dart';
import 'profile_step_1_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ProfileStep1Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OnboardingMatchmakingScreen(onNext: _next, onSkip: _finish),
          OnboardingChatSquadsScreen(onNext: _next, onSkip: _finish),
          OnboardingReputationScreen(onFinish: _finish),
        ],
      ),
    );
  }
}
