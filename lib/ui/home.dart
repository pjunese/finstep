import 'package:flutter/material.dart';
import '../state/progress.dart';
import '../state/account.dart';
import '../state/profile.dart';
import 'theme.dart';
import 'explore.dart';
import 'brand.dart';
import 'home_feed.dart';
import 'profile.dart';

class HomeShell extends StatefulWidget {
  const HomeShell(this.c, this.profile, this.account, {super.key});
  final ProfileController profile;
  final AccountController account;
  final LearningController c;
  @override
  State<HomeShell> createState() => _HomeState();
}

class _HomeState extends State<HomeShell> {
  int tab = 0;
  bool connections = false;
  final collapsed = <int>{1, 2, 3, 4, 5, 6};
  LearningController get c => widget.c;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) {
      if (!c.ready) {
        return Scaffold(
          body: SafeArea(
            child: PageBody([
              Text('기록을 준비하고 있어요.', style: F.title),
              if (c.error != null) Note(c.error!),
              if (c.busy)
                const CircularProgressIndicator()
              else
                ActionButton('다시 불러오기', onTap: c.load),
            ]),
          ),
        );
      }
      return Scaffold(
        backgroundColor: tab == 0 ? const Color(0xfff8f9fb) : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 24,
          title: tab == 0
              ? Row(
                  children: [
                    const BrandMark(size: 28),
                    const SizedBox(width: 9),
                    Text('핀스텝', style: F.section),
                  ],
                )
              : Text(['핀스텝', '학습', '마이페이지'][tab], style: F.section),
          actions: [
            if (tab == 2)
              IconButton(
                tooltip: '설정',
                onPressed: () =>
                    openSettings(context, widget.profile, widget.account),
                icon: const Icon(Icons.settings_outlined),
              ),
            if (tab == 0)
              IconButton(
                tooltip: '개념 찾기',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SearchScreen(c)),
                ),
                icon: const Icon(Icons.search_rounded),
              ),
          ],
        ),
        body: PageBody(key: ValueKey('$tab-$connections'), [
          if (c.error != null) Note(c.error!),
          ...switch (tab) {
            0 => [HomeFeed(c, onCourse: () => setState(() => tab = 1))],
            1 => map(),
            _ => [MyPage(c, widget.profile, widget.account)],
          },
        ]),
        bottomNavigationBar: ColoredBox(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Expanded(
                      child: Semantics(
                        selected: tab == i,
                        button: true,
                        label: ['홈', '학습', '마이'][i],
                        excludeSemantics: true,
                        onTap: () => setState(() => tab = i),
                        child: InkWell(
                          onTap: () => setState(() => tab = i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: VStack(
                              [
                                Icon(
                                  [
                                    Icons.home_rounded,
                                    Icons.account_tree_outlined,
                                    Icons.person_outline_rounded,
                                  ][i],
                                  size: 23,
                                  color: i == tab ? F.orange : F.secondary,
                                ),
                                Text(
                                  ['홈', '학습', '마이'][i],
                                  style: F.meta.copyWith(
                                    color: i == tab ? F.ink : F.secondary,
                                  ),
                                ),
                              ],
                              gap: 4,
                              cross: CrossAxisAlignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  List<Widget> map() => [
    Row(
      children: [
        for (var i = 0; i < 2; i++)
          Expanded(
            child: InkWell(
              onTap: () => setState(() => connections = i == 1),
              child: VStack([
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    ['학습 과정', '개념 연결'][i],
                    style: F.label.copyWith(
                      color: connections == (i == 1) ? F.ink : F.secondary,
                    ),
                  ),
                ),
                Container(
                  height: 2,
                  color: connections == (i == 1) ? F.orange : F.line,
                ),
              ], gap: 0),
            ),
          ),
      ],
    ),
    if (connections)
      Connections(c)
    else ...[
      Text('주식부터 경제 뉴스까지', style: F.meta),
      Text('꼭 알아둘\n핵심 개념 50', style: F.heading),
      Text(
        '${c.completed.length} / ${c.course.lessons.length} 완료',
        style: F.meta,
      ),
      ProgressLine(c.completed.length / c.course.lessons.length),
      for (
        var chapter = 0;
        chapter < c.course.categories.length;
        chapter++
      ) ...[
        InkWell(
          onTap: () => setState(
            () => collapsed.contains(chapter)
                ? collapsed.remove(chapter)
                : collapsed.add(chapter),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${chapter + 1}. ${c.course.categories[chapter]['title']}',
                    style: F.section,
                  ),
                ),
                Text(collapsed.contains(chapter) ? '›' : '⌄', style: F.section),
              ],
            ),
          ),
        ),
        Text(
          '${c.course.inCategory(c.course.categories[chapter]['id']).where((l) => c.completed.contains(l.id)).length} / ${c.course.inCategory(c.course.categories[chapter]['id']).length} 완료 · ${c.course.categories[chapter]['description']}',
          style: F.meta,
        ),
        if (!collapsed.contains(chapter))
          VStack(
            c.course
                .inCategory(c.course.categories[chapter]['id'])
                .map(
                  (l) => LinkRow(
                    l.title,
                    c.completed.contains(l.id)
                        ? '학습 완료'
                        : c.session(l.id) != null
                        ? '이어서 학습 · 짧게 한 개념'
                        : '짧게 한 개념 · 바로 학습 가능',
                    marker: c.completed.contains(l.id)
                        ? '✓'
                        : (c.course.lessons.indexOf(l) + 1).toString().padLeft(
                            2,
                            '0',
                          ),
                    active:
                        l.id == c.nextLesson.id && !c.completed.contains(l.id),
                    onTap: () => openLesson(context, c, l),
                  ),
                )
                .toList(),
            gap: 4,
          ),
        const Divider(),
      ],
      const Note('추천 순서는 있지만 잠긴 레슨은 없어요. 필요한 개념부터 살펴보고, 앞 개념으로 돌아올 수 있어요.'),
    ],
  ];
}
