import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class OnboardingData {
  final Color color;
  final String question;
  final String answerHighlight;
  final String answerDetail;

  OnboardingData({
    required this.color,
    required this.question,
    required this.answerHighlight,
    required this.answerDetail,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    color: const Color(0xFF39B54A),
    question: "How much\nof my earnings\ndo I get to keep?",
    answerHighlight: "100%.",
    answerDetail: "We charge zero\ncommission on\nyour sales.",
  ),
  OnboardingData(
    color: const Color(0xFF2980B9),
    question: "Will I get paid\non time,\nand is it safe?",
    answerHighlight: "Always.",
    answerDetail: "Payments are\nsecure and\non-time,\nevery time.",
  ),
  OnboardingData(
    color: const Color(0xFF8E44AD),
    question: "Can I reach more\ncustomers beyond\nmy area?",
    answerHighlight: "Yes!",
    answerDetail: "We deliver to\n20,000+ pin codes\nacross India.",
  ),
  OnboardingData(
    color: const Color(0xFFE67E22),
    question: "What if most of my\nsales happen offline?",
    answerHighlight: "No worries",
    answerDetail: "offline exposure is\npart of the plan.",
  ),
  OnboardingData(
    color: const Color(0xFFF44336),
    question: "How do I minimize\nreturns and losses?",
    answerHighlight: "With us,",
    answerDetail: "you get fewer\nreturns and\nmore profit.",
  ),
];

class VerticalOnboardingScreen extends ConsumerStatefulWidget {
  const VerticalOnboardingScreen({super.key});

  @override
  ConsumerState<VerticalOnboardingScreen> createState() =>
      _VerticalOnboardingScreenState();
}

class _VerticalOnboardingScreenState
    extends ConsumerState<VerticalOnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentPageProvider);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const SinglePageScrollPhysics(),
            onPageChanged: (index) {
              ref.read(currentPageProvider.notifier).state = index;
            },
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return AnimatedPage(
                data: onboardingPages[index],
                pageIndex: index,
              );
            },
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 24.0),
                child: AnimatedOpacity(
                  opacity: currentIndex > 0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: currentIndex == 0,
                    child: InkWell(
                      onTap: () {
                        print("Skip tapped! Time to go to the main app.");
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "SKIP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedPage extends ConsumerStatefulWidget {
  final OnboardingData data;
  final int pageIndex;

  const AnimatedPage({super.key, required this.data, required this.pageIndex});

  @override
  ConsumerState<AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends ConsumerState<AnimatedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  void _triggerAnimation() {
    if (_hasTriggered) return;
    _hasTriggered = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = ref.watch(currentPageProvider);
    final isActive = currentPageIndex == widget.pageIndex;

    if (isActive) {
      _triggerAnimation();
    } else {
      _controller.reset();
      _hasTriggered = false;
    }

    return Container(
      color: widget.data.color,
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double t = _controller.value;

          final double phase1Time = (t / 0.16).clamp(0.0, 1.0);
          final double phase2Time = ((t - 0.90) / 0.10).clamp(0.0, 1.0);

          // question animation
          double qOpacity = t <= 0.16
              ? Curves.easeOut.transform(phase1Time)
              : 1.0;

          final screenHeight = MediaQuery.of(context).size.height;

          double qY = t <= 0.16
              ? Tween<double>(
                  begin: screenHeight / 2,
                  end: 120.0,
                ).transform(Curves.easeOut.transform(phase1Time))
              : (t < 0.90
                    ? 120.0
                    : Tween<double>(
                        begin: 120.0,
                        end: 0.0,
                      ).transform(Curves.easeOut.transform(phase2Time)));

          Color? qColor = t < 0.90
              ? Colors.white
              : ColorTween(
                  begin: Colors.white,
                  end: const Color(0xCC000000),
                ).transform(Curves.easeOut.transform(phase2Time));

          double qSize = t < 0.90
              ? 38.0
              : Tween<double>(
                  begin: 38.0,
                  end: 32.0,
                ).transform(Curves.easeOut.transform(phase2Time));

          // answer animation
          double aOpacity = t < 0.90
              ? 0.0
              : Curves.easeOut.transform(phase2Time);

          double aX = t < 0.90
              ? 200.0
              : Tween<double>(
                  begin: 200,
                  end: 0,
                ).transform(Curves.easeOut.transform(phase2Time));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, qY),
                child: Opacity(
                  opacity: qOpacity,
                  child: Text(
                    widget.data.question,
                    style: TextStyle(
                      fontSize: qSize,
                      fontWeight: FontWeight.bold,
                      color: qColor,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Transform.translate(
                offset: Offset(aX, 0),
                child: Opacity(
                  opacity: aOpacity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.answerHighlight,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.data.answerDetail,
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SinglePageScrollPhysics extends ScrollPhysics {
  const SinglePageScrollPhysics({super.parent});

  @override
  SinglePageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SinglePageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = toleranceFor(position);
    final double page = position.pixels / position.viewportDimension;

    final double currentPage = page.roundToDouble();

    double targetPage = currentPage;
    if (velocity < -tolerance.velocity) {
      targetPage = currentPage - 1.0;
    } else if (velocity > tolerance.velocity) {
      targetPage = currentPage + 1.0;
    }

    final double targetPixels = targetPage * position.viewportDimension;

    if (targetPixels != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        targetPixels,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
