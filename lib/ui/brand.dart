import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 88});
  final double size;
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/icons/brand-mark.svg',
    width: size,
    height: size,
    semanticsLabel: '핀스텝 로고',
  );
}

class BrandSplash extends StatelessWidget {
  const BrandSplash({super.key, this.failed = false, this.onRetry});
  final bool failed;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: VStack([
              const BrandMark(),
              const SizedBox(height: 8),
              Text('핀스텝', style: F.text(32, weight: FontWeight.w700)),
              Text(
                '하나씩 배우고, 조금씩 연결해요.',
                style: F.body.copyWith(color: F.secondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Semantics(
                liveRegion: true,
                child: Text(
                  failed ? '앱을 준비하지 못했어요.' : '학습을 준비하고 있어요.',
                  style: F.meta,
                ),
              ),
              if (failed) ActionButton('다시 시도', onTap: onRetry),
            ], cross: CrossAxisAlignment.center),
          ),
        ),
      ),
    ),
  );
}
