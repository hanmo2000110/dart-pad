# Microlearnable DartPad

Microlearnable DartPad는 오픈소스
[DartPad](https://github.com/dart-lang/dart-pad) 클라이언트를 기반으로,
개발도상국 학생을 위한 Flutter 학습 플랫폼 Microlearnable에 맞게
커스터마이징한 임베디드 코드 실습 환경입니다.

원본 DartPad의 코드 편집, 정적 분석, 컴파일, iframe 실행 구조는 유지하면서
Microlearnable 수업 흐름에 필요한 강의 코드 로딩, 제출, 채점, 학습 기록 저장
기능을 추가했습니다.

## 프로젝트 목적

- Microlearnable 수업 페이지 안에서 Dart/Flutter 실습을 바로 진행할 수 있도록
  DartPad를 iframe 기반으로 임베딩합니다.
- Firebase에 저장된 강의 코드와 학습자 기록을 불러와 개인별 실습 상태를
  복원합니다.
- 제출 및 재제출 흐름을 제공하고, 점수와 제출 시간을 학습 기록에 반영합니다.
- 정답, 오답, 로딩, 완료 상태를 별도 결과 다이얼로그와 시각 피드백으로
  보여줍니다.
- `courseId`, `chapterId`, `lessonId`, `uid` 등 플랫폼 연동에 필요한 query
  parameter를 지원합니다.

## 주요 커스터마이징

주요 변경 지점은 다음과 같습니다.

- `lib/embed.dart`: 임베드 초기화, Firebase 기반 강의 코드 로딩, 결과 다이얼로그
  제어, 제출/재제출 흐름을 담당합니다.
- `lib/sharing/editor_ui.dart`: 실행 및 테스트 제출 시 사용자 코드와 테스트 코드를
  조합해 Dart services로 전달합니다.
- `lib/util/query_params.dart`: Microlearnable 연동에 필요한 `courseId`,
  `chapterId`, `lessonId`, `uid`, `gutter` parameter를 추가했습니다.
- `lib/services/dartservices.dart`: Dart services 요청 전에 Firebase Storage URL
  proxy 처리를 수행합니다.
- `web/embed-dart.html`, `web/embed-flutter.html`: 제출 버튼, 점수, 제출 시간,
  결과 모달을 포함한 임베드 화면 구조를 커스터마이징했습니다.
- `web/*_lottie.json`, `web/num*.png`, `web/submit_arrow.png`: 학습자 피드백에
  사용되는 시각 리소스입니다.

구현 흐름과 유지보수 메모는
[`docs/MICROLEARNABLE_CUSTOMIZATION.md`](docs/MICROLEARNABLE_CUSTOMIZATION.md)에
정리했습니다.

## 설정

Firebase 프로젝트 값은 소스 코드에 직접 하드코딩하지 않고
`String.fromEnvironment`를 통해 빌드 시점에 주입합니다. DartPad가 사용하는
`build_web_compilers` 설정에 환경 값을 전달하면 됩니다.

`dart2js` 빌드에서는 `dart2js_args`에 `-D` 값을 추가합니다.

```yaml
targets:
  $default:
    builders:
      build_web_compilers|entrypoint:
        options:
          dart2js_args:
          - -DMICROLEARNABLE_FIREBASE_API_KEY=...
          - -DMICROLEARNABLE_FIREBASE_AUTH_DOMAIN=...
          - -DMICROLEARNABLE_FIREBASE_DATABASE_URL=...
          - -DMICROLEARNABLE_FIREBASE_PROJECT_ID=...
          - -DMICROLEARNABLE_FIREBASE_APP_ID=...
          - -DMICROLEARNABLE_FIREBASE_STORAGE_BUCKET=...
```

DDC 개발 빌드에서는 `global_options`의 `environment`에 같은 값을 추가합니다.

```yaml
global_options:
  build_web_compilers:ddc:
    options:
      environment:
        MICROLEARNABLE_FIREBASE_API_KEY: ...
        MICROLEARNABLE_FIREBASE_AUTH_DOMAIN: ...
        MICROLEARNABLE_FIREBASE_DATABASE_URL: ...
        MICROLEARNABLE_FIREBASE_PROJECT_ID: ...
        MICROLEARNABLE_FIREBASE_APP_ID: ...
        MICROLEARNABLE_FIREBASE_STORAGE_BUCKET: ...
```

선택 설정:

- `MICROLEARNABLE_FIREBASE_AUTH_EMAIL`
- `MICROLEARNABLE_FIREBASE_AUTH_PASSWORD`
- `MICROLEARNABLE_STORAGE_CORS_PROXY`

이메일/비밀번호 인증 값이 없으면 익명 Firebase 인증을 시도합니다. 이 경우
Firestore 보안 규칙도 해당 인증 방식에 맞게 구성되어야 합니다.

## 로컬 실행

의존성 설치:

```bash
dart pub get
```

정적 분석 및 테스트:

```bash
dart analyze
dart test
```

로컬 서버 실행:

```bash
dart run grinder serve
```

## 원본 프로젝트

이 저장소는 Dart와 Flutter 학습을 위한 오픈소스 온라인 에디터 DartPad를
기반으로 합니다. 원본 프로젝트는 Dart 팀이 관리하며
[dart-lang/dart-pad](https://github.com/dart-lang/dart-pad)에서 확인할 수
있습니다.

원본 BSD-style 라이선스는 [`LICENSE`](LICENSE)에 유지되어 있습니다.
