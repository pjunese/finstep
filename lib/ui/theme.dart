import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

abstract final class F {
  static const ink = Color(0xff1d2430),
      secondary = Color(0xff606770),
      orange = Color(0xffff9554),
      soft = Color(0xfffff0e6),
      line = Color(0xffe4e8ec),
      neutral = Color(0xfff2f5f7);
  static TextStyle text(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = ink,
    double? height,
  }) => TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: -.3,
    height: height ?? 1.55,
  );
  static final title = text(28, weight: FontWeight.w700, height: 38 / 28),
      heading = text(22, weight: FontWeight.w700, height: 32 / 22),
      section = text(17, weight: FontWeight.w700, height: 24 / 17),
      body = text(16, height: 26 / 16),
      label = text(14, weight: FontWeight.w500, height: 22 / 14),
      meta = text(12, color: secondary, height: 1.5);
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSansKR',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: orange,
      primary: orange,
      onPrimary: ink,
      surface: Colors.white,
      onSurface: ink,
    ),
    splashFactory: NoSplash.splashFactory,
    dividerColor: line,
    dividerTheme: const DividerThemeData(color: line, thickness: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: label,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    textTheme: TextTheme(
      bodyMedium: body,
      bodyLarge: body,
      titleLarge: heading,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
  );
}

class VStack extends StatelessWidget {
  const VStack(
    this.children, {
    super.key,
    this.gap = 16,
    this.cross = CrossAxisAlignment.start,
  });
  final List<Widget> children;
  final double gap;
  final CrossAxisAlignment cross;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: cross,
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) SizedBox(height: gap),
        children[i],
      ],
    ],
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label, {
    super.key,
    required this.onTap,
    this.secondary = false,
    this.compact = false,
  });
  final String label;
  final VoidCallback? onTap;
  final bool secondary, compact;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: compact ? null : double.infinity,
    child: TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: F.ink,
        disabledForegroundColor: F.secondary,
        backgroundColor: onTap == null
            ? F.line
            : secondary
            ? Colors.white
            : F.orange,
        minimumSize: Size(compact ? 70 : 0, compact ? 44 : 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: secondary ? const BorderSide(color: F.line) : BorderSide.none,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: F.text(16, weight: FontWeight.w700, height: 1.5),
      ),
    ),
  );
}

class CardBox extends StatelessWidget {
  const CardBox({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 16,
    this.border = true,
  });
  final Widget child;
  final Color color;
  final double padding;
  final bool border;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(18),
      border: border ? Border.all(color: F.line) : null,
    ),
    child: child,
  );
}

class Note extends StatelessWidget {
  const Note(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => CardBox(
    color: F.neutral,
    border: false,
    padding: 16,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('i', style: F.section),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: F.label)),
      ],
    ),
  );
}

class Copy extends StatelessWidget {
  const Copy(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => MarkdownBody(
    data: text,
    selectable: false,
    styleSheet: MarkdownStyleSheet(
      p: F.body,
      h3: F.section,
      h2: F.heading,
      strong: F.body.copyWith(fontWeight: FontWeight.w700),
      listBullet: F.body,
      tableHead: F.meta.copyWith(fontWeight: FontWeight.w700),
      tableBody: F.label,
      tableCellsPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 6,
      ),
      tableBorder: const TableBorder(
        horizontalInside: BorderSide(color: F.line),
      ),
      blockquoteDecoration: BoxDecoration(
        color: F.neutral,
        borderRadius: BorderRadius.circular(12),
      ),
      code: F.label.copyWith(backgroundColor: F.neutral),
      codeblockDecoration: BoxDecoration(
        color: F.neutral,
        borderRadius: BorderRadius.circular(12),
      ),
      blockSpacing: 16,
    ),
  );
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key});
  final String name;
  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset('assets/icons/$name.svg');
}

class FocusBar extends StatelessWidget implements PreferredSizeWidget {
  const FocusBar(this.title, {super.key, this.onBack, this.onClose});
  final String title;
  final VoidCallback? onBack, onClose;
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(title),
    automaticallyImplyLeading: false,
    leading: onBack == null
        ? null
        : IconButton(
            tooltip: '뒤로',
            onPressed: onBack,
            icon: const AppIcon('back'),
          ),
    actions: [
      if (onClose != null)
        IconButton(
          tooltip: '닫기',
          onPressed: onClose,
          icon: const AppIcon('close'),
        ),
      const SizedBox(width: 8),
    ],
  );
}

class PageBody extends StatelessWidget {
  const PageBody(this.children, {super.key, this.gap = 16, this.controller});
  final List<Widget> children;
  final double gap;
  final ScrollController? controller;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: controller,
    padding: const EdgeInsets.all(24),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SizedBox(
          width: double.infinity,
          child: VStack(children, gap: gap),
        ),
      ),
    ),
  );
}

class Footer extends StatelessWidget {
  const Footer(this.children, {super.key});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(24, 8, 24, 16),
    child: Align(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: VStack(children, gap: 8),
      ),
    ),
  );
}

class Steps extends StatelessWidget {
  const Steps(this.current, {super.key});
  final int current;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < 3; i++) ...[
        if (i > 0) const SizedBox(width: 8),
        Expanded(
          child: VStack(
            [
              Container(height: 3, color: i <= current ? F.orange : F.line),
              Text(['읽기', '적용', '연결'][i], style: F.meta),
            ],
            gap: 6,
            cross: CrossAxisAlignment.center,
          ),
        ),
      ],
    ],
  );
}

class ProgressLine extends StatelessWidget {
  const ProgressLine(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) => LinearProgressIndicator(
    value: value,
    minHeight: 4,
    color: F.orange,
    backgroundColor: F.line,
    semanticsLabel: '코스 진행',
    semanticsValue: '${(value * 100).round()}',
  );
}

class LinkRow extends StatelessWidget {
  const LinkRow(
    this.title,
    this.subtitle, {
    super.key,
    required this.onTap,
    this.marker = '↗',
    this.active = false,
  });
  final String title, subtitle, marker;
  final VoidCallback onTap;
  final bool active;
  @override
  Widget build(BuildContext context) => Material(
    color: active ? F.soft : Colors.transparent,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? F.orange : F.neutral,
                shape: BoxShape.circle,
              ),
              child: Text(marker, style: F.label),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VStack([
                Text(title, style: F.label),
                Text(subtitle, style: F.meta),
              ], gap: 3),
            ),
            const SizedBox(width: 8),
            Text('›', style: F.section),
          ],
        ),
      ),
    ),
  );
}

class ConceptPair extends StatelessWidget {
  const ConceptPair(
    this.left,
    this.leftDetail,
    this.right,
    this.rightDetail, {
    super.key,
  });
  final String left, leftDetail, right, rightDetail;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: CardBox(
          padding: 12,
          color: F.neutral,
          border: false,
          child: VStack([
            Text(left, style: F.section),
            Text(leftDetail, style: F.meta),
          ], gap: 8),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12),
        child: Text('→', style: F.section),
      ),
      Expanded(
        child: CardBox(
          padding: 12,
          color: F.soft,
          border: false,
          child: VStack([
            Text(right, style: F.section),
            Text(rightDetail, style: F.meta),
          ], gap: 8),
        ),
      ),
    ],
  );
}

/// A quiet secondary action: the main learning path never requires opening it.
class DetailLink extends StatelessWidget {
  const DetailLink(this.label, {super.key, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: F.secondary,
        minimumSize: const Size(44, 44),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      ),
      child: Text('$label  ›', style: F.label.copyWith(color: F.secondary)),
    ),
  );
}
