import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/layers/presentation/assets.dart';
import 'package:rickmorty/layers/presentation/styles.dart';
import 'package:rickmorty/layers/presentation/shared/ui_effects/lit_image.dart';

class FgAppStack extends StatefulWidget {
  const FgAppStack({super.key, required this.body});

  final Widget body;

  @override
  State<FgAppStack> createState() => _FgAppStackState();
}

class _FgAppStackState extends State<FgAppStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    final tween = Tween<double>(begin: 0.1, end: 1.0).animate(_controller);
    _animation = CurvedAnimation(curve: Curves.bounceInOut, parent: tween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normal = AppColors.normalColors[0];
    final emitColor = AppColors.emitColors[0];
    const finalReceiveLightAmt = 0.3;

    return FutureProvider<FragmentPrograms?>(
      create: (context) => loadFragmentPrograms(),
      initialData: null,
      child: Stack(
        children: [
          // Bg
          Positioned.fill(
            child: Image.asset(
              Asset.bgBase,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: LitImage(
              color: normal,
              imgSrc: Asset.bgLightReceive,
              lightAmt: finalReceiveLightAmt,
              fit: BoxFit.cover,
              scale: 5.8,
            ),
          ),

          // BODY
          widget.body,

          // MD
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: IgnorePointer(
              child: LitImage(
                color: normal,
                imgSrc: Asset.mgBaseBottom,
                lightAmt: finalReceiveLightAmt,
                fit: BoxFit.cover,
                scale: 7.8,
              ),
            ),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: IgnorePointer(
              child: LitImage(
                color: normal,
                imgSrc: Asset.mgLightReceiveBottom,
                lightAmt: finalReceiveLightAmt,
                fit: BoxFit.cover,
                scale: 7.8,
              ),
            ),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return IgnorePointer(
                  child: LitImage(
                    color: emitColor,
                    imgSrc: Asset.mgLightEmitBottom,
                    lightAmt: _animation.value,
                    fit: BoxFit.cover,
                    scale: 1.0,
                  ),
                );
              },
            ),
          ),

          // FG-Base

          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: IgnorePointer(
              child: LitImage(
                color: normal,
                imgSrc: Asset.fgBase,
                lightAmt: finalReceiveLightAmt,
                fit: BoxFit.contain,
                scale: 1,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: IgnorePointer(
              child: LitImage(
                color: normal,
                imgSrc: Asset.fgLightReceive,
                lightAmt: finalReceiveLightAmt,
                fit: BoxFit.contain,
                scale: 1,
              ),
            ),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: LitImage(
                      color: emitColor,
                      imgSrc: Asset.fgEmit,
                      lightAmt: _animation.value,
                      fit: BoxFit.contain,
                      scale: 1,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
