import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'content/course.dart';
import 'state/progress.dart';
import 'state/profile.dart';
import 'state/account.dart';
import 'ui/brand.dart';
import 'ui/home.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Noto Sans KR',
    ], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
  runApp(const Bootstrap());
}

class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});
  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  LearningController? controller;
  ProfileController? profile;
  AccountController? account;
  bool failed = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => failed = false);
    try {
      final course = await Course.load();
      course.validate();
      final dir = await getApplicationSupportDirectory();
      final c = LearningController(
        course,
        FileProgressStore(Directory('${dir.path}/finstep')),
      );
      final p = ProfileController(
        ProfileFileStore(Directory('${dir.path}/finstep')),
      );
      final a = AccountController(const UnconfiguredAuthGateway());
      await Future.wait([c.load(), p.load(), a.restore()]);
      if (mounted) {
        setState(() {
          controller = c;
          profile = p;
          account = a;
        });
      } else {
        c.dispose();
        p.dispose();
        a.dispose();
      }
    } catch (_) {
      if (mounted) setState(() => failed = true);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    profile?.dispose();
    account?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return FinStepApp(
        controller: controller!,
        profile: profile,
        account: account,
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: F.theme,
      home: BrandSplash(failed: failed, onRetry: load),
    );
  }
}

class FinStepApp extends StatefulWidget {
  const FinStepApp({
    super.key,
    required this.controller,
    this.profile,
    this.account,
  });
  final LearningController controller;
  final ProfileController? profile;
  final AccountController? account;
  @override
  State<FinStepApp> createState() => _FinStepAppState();
}

class _FinStepAppState extends State<FinStepApp> {
  // In-memory defaults are for isolated previews/tests; Bootstrap injects disk storage.
  ProfileController? fallbackProfile;
  AccountController? fallbackAccount;
  @override
  void initState() {
    super.initState();
    if (widget.profile == null) {
      fallbackProfile = ProfileController(MemoryProgressStore())..load();
    }
    if (widget.account == null) {
      fallbackAccount = AccountController(const UnconfiguredAuthGateway())
        ..restore();
    }
  }

  @override
  void dispose() {
    fallbackProfile?.dispose();
    fallbackAccount?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '핀스텝',
    debugShowCheckedModeBanner: false,
    theme: F.theme,
    home: HomeShell(
      widget.controller,
      widget.profile ?? fallbackProfile!,
      widget.account ?? fallbackAccount!,
    ),
  );
}
