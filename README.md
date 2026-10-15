# 핀스텝 · FinStep

Figma의 Product Orange 시안과 루트 폴더의 MD 콘텐츠를 바탕으로 만든 iOS·Android Flutter 앱입니다.

## 실행

개발 기준: Flutter 3.41.6 / Dart 3.11.4. 실제 로컬 버전은 `flutter --version`으로 확인하세요.

```sh
flutter pub get
dart run tool/import_content.dart
flutter run
```

`flutter devices`로 기기를 확인한 뒤 `flutter run -d <device-id>`로 지정할 수 있습니다. iOS는 Xcode와 시뮬레이터 또는 개발용 서명이 설정된 기기가 필요합니다. Android는 에뮬레이터 또는 USB 디버깅을 허용한 기기를 사용합니다.

## 현재 구현

- 첫 방문부터 바로 참여하는 홈: 오늘의 한입 질문 → 짧은 해설 → 관련 레슨
- 미완료 학습·복습 이어가기, 관심 질문 카드, 실제 기록 기반 주간 발자국
- 하루 1~3개 학습 목표, 끝까지 마친 개념만 하루 한 번 집계
- 복습 시점과 오답을 반영한 추천, 완료 화면의 다음 복습 날짜
- 학습 과정, 접기/펼치기, 자유로운 레슨 선택
- 핵심 50개를 7개 분류로 구성: 짧은 핵심 → 작은 예시/가상 뉴스 → 퀴즈 2개
- 150문항, 한 문장 피드백, 선택형 상세 설명과 전체 해설
- 개념마다 본 학습 2문항과 별도 복습용 새 문항 1개
- 50개 홈 한입 질문, 분류 검색, 50개 개념 중심 관계 탐색
- 이전 8레슨 과정의 기록·XP는 별도로 보존
- 오답 복습, 미해결 문항 표시, 개념 연결·상세·검색·저장
- 기기 내 진행 저장과 이어하기, 저장 실패 안내, 최초 완료 때만 30 XP
- 가입과 서버 없이 콘텐츠·폰트·아이콘을 포함해 오프라인 실행
- 마이페이지: 닉네임·프로필 색상 수정, 학습 기록·오답·저장한 개념 연결
- 설정: 계정 관리, 데이터 보관 안내, FAQ, 앱 정보·라이선스
- Google·카카오·네이버·Apple 로그인·회원가입 준비 화면과 인증 연결 구조
- iOS·Android 앱 아이콘과 시작 화면, 자료 준비·실패·재시도 화면

0.5.0은 실제 SNS 로그인과 서버 연결 전 단계입니다. 로그인 버튼은 `준비 중`으로 표시되고 실제 계정을 만들지 않습니다. 현재 데이터는 기기에 저장됩니다. 학습 목표·복습 규칙과 출시 준비 현황은 [학습 목표와 출시 준비 문서](docs/10_Daily_Study_And_Release.md), 홈의 설계는 [홈 경험 문서](docs/08_Home_Experience.md), 계정 후속 연결 지점은 [계정 연결 문서](docs/07_Account_Integration.md)에 정리했습니다.

활동 레벨은 `1 + 누적 XP ~/ 100`입니다. 개념 이해도나 투자 능력을 판정하는 점수가 아닙니다. 오답이 있어도 레슨을 마칠 수 있고, 복습과 재학습은 XP를 추가 지급하지 않습니다.

## 콘텐츠 수정

현재 콘텐츠 원본은 **[08_Core_50_Data.md](08_Core_50_Data.md)**입니다. 분류 변경과 주요 오류 교정은 [점검 보고서](docs/09_Core_50_Audit.md)에 정리했습니다.

원고의 JSON 블록을 수정한 뒤 `dart run tool/import_content.dart`를 실행합니다. 앱용 `assets/data/course.json`이 생성됩니다. `--check` 옵션으로 원본과 생성 파일의 일치 여부를 확인합니다. 핵심·예시·자세한 설명·가상 뉴스·홈 질문·퀴즈·분류·관계를 한 원본에서 관리합니다.

`05_Concept_Map_Data.md`, `06_Concept_Content_Data.md`, `07_Quiz_Data.md`는 이전 과정의 참고 기록으로 남기며 현재 앱 원본으로 가져오지 않습니다. 구버전 콘텐츠는 `docs/archive/course-v0.3.0.json`에 보존하고 기록 이전의 검증에 사용합니다. 사용자 첨부 원본은 `docs/archive/50-original.md`에 있습니다.

## 구조

- `lib/content/`: 콘텐츠 모델·검증, 데이터 기반 홈 한입 질문
- `lib/state/progress.dart`: 학습 전이, 이벤트, XP, 파일 저장
- `lib/state/study_plan.dart`: 일일 목표·복습 일정·기존 기록 호환 검증
- `lib/state/profile.dart`: 기기 내 프로필 저장·검증
- `lib/state/account.dart`: 인증 인터페이스·상태 관리, 기본 미연결 어댑터
- `lib/ui/`: Figma 디자인 토큰과 화면
- `tool/import_content.dart`: MD → JSON 변환
- `test/`: 콘텐츠·저장·학습·레이아웃 테스트
- `integration_test/`, `test_driver/`: 실제 시뮬레이터/에뮬레이터 테스트와 화면 캡처

한입 선택 기록은 학습 파일의 선택적 `homeAnswers`에 별도로 저장하며 XP·코스 정오답에는 합산하지 않습니다.

진행 데이터의 내부 스키마는 2입니다. 이전 기록 전체를 `legacy`로 보존하며 새 과정의 완료로 변환하지 않습니다. 이전 XP와 주간 참여 이력은 유지하고 마이페이지 학습 기록에서 이전 과정의 내역을 확인할 수 있습니다.

0.5.0의 선택적 `studyPlan`에는 목표, 최근 90개의 완료 활동 날짜, 개념별 다음 복습 날짜를 저장합니다. 이전 파일은 수정 없이 읽을 수 있고, 과거 학습 날짜를 임의로 만들어 목표 실적에 넣지 않습니다. 복습은 앱 내 추천이며 푸시 알림은 아직 없습니다.

진행 데이터는 앱의 Application Support 디렉터리 아래 `finstep/progress-v1.json`, 닉네임과 프로필 색상은 별도 `finstep/profile-v1.json`에 저장합니다. 임시 파일을 flush한 후 같은 디렉터리에서 rename해 반영하며 직전 스냅샷은 `.backup`에 보관합니다. 읽기 실패·알 수 없는 스키마에서는 자동 초기화하지 않습니다. 계정 동기화나 클라우드 백업 기능은 없습니다. 앱 삭제 시 기록이 사라질 수 있습니다.

## 검사

```sh
dart run tool/import_content.dart --check
flutter analyze
flutter test
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d <device-id>
```

통합 테스트는 실제 앱 기록과 분리된 임시 저장소를 사용합니다. 캡처는 `work/ios-*.png` 또는 `work/android-*.png`에 저장됩니다.

공용 에뮬레이터는 테스트 시작 전에 홈 화면으로 이동합니다. `flutter drive`가 끝나면 테스트 앱이 닫히므로, 이후 일반 `lib/main.dart` 빌드를 설치·실행하고 핀스텝이 앞에 표시되는지 확인합니다. 이전에 열렸던 다른 앱 화면을 핀스텝의 실행 결과로 착각하지 않도록 주의합니다.

## 빌드

```sh
flutter build apk --debug
flutter build ios --simulator --debug --target lib/main.dart
```

Android 개발용 설치 파일은 `build/app/outputs/flutter-apk/app-debug.apk`입니다. 스토어 제출 파일이 아닙니다. Android 출시 빌드는 개인 업로드 키를 연결해야 합니다. `android/key.properties.example`을 참고해 로컬 `android/key.properties`를 작성합니다. 실제 키와 비밀번호는 버전 관리에 넣지 않습니다.

```sh
# 정식 키 설정 후 Google Play용 AAB 생성
flutter build appbundle --release --target lib/main.dart
```

0.5.0부터 정식 키가 없으면 release 빌드를 중단합니다. 개발용 서명으로 대체하지 않습니다. `targetSdk`는 36이며, 현재 앱 식별자 `dev.finstep.finstep`은 최초 게시 전에 확정해야 합니다. 실제 SNS 인증, 서버 동기화, 서명한 AAB의 Play Console 검증은 아직 수행하지 않았습니다. 검증 범위와 남은 작업은 [출시 준비 현황](docs/10_Daily_Study_And_Release.md)을 확인하세요.

iPhone 실기기 설치와 TestFlight/App Store 배포는 개발자 팀·서명·프로비저닝 설정이 필요합니다. `flutter build ios --release --no-codesign --target lib/main.dart` 결과는 그 자체로 iPhone에 설치할 수 있는 IPA가 아닙니다.

## 디자인

[핀스텝 Figma 원본](https://www.figma.com/design/AMc3Jn0vkKhmPFlMbhLFJN?node-id=0-1)

시안의 Noto Sans KR, Orange 색상, 원본 SVG를 번들에 포함합니다. 상태 표시줄과 홈 인디케이터는 각 OS가 표시하도록 두고, 본문은 화면 크기와 글자 확대에 맞춰 스크롤됩니다. Figma의 샘플 진도·정답·XP를 실제 학습 기록으로 대체했습니다. 상세한 구현 결정은 `docs/06_Implementation_Notes.md`에 기록합니다.
