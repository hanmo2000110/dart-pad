# Microlearnable 커스터마이징 정리

이 문서는 원본 DartPad 위에 Microlearnable 플랫폼 연동을 위해 추가한 내용을
정리합니다. 리뷰어가 프로젝트의 목적, 변경 범위, 데이터 흐름을 빠르게 이해할
수 있도록 작성했습니다.

## 목표

Microlearnable은 수업 페이지 안에서 바로 코드를 작성하고 실행하는 실습 경험을
제공합니다. 이 프로젝트는 DartPad를 임베디드 코드 에디터로 활용해 학습자가
Flutter/Dart 코드를 작성하고, 제출하고, 결과를 확인하며, 학습 기록을 Firebase에
저장할 수 있도록 확장했습니다.

## 연동 흐름

1. 호스트 플랫폼이 `uid`, `courseId`, `chapterId`, `lessonId` 등의 query
   parameter와 함께 DartPad 임베드 페이지를 로드합니다.
2. 임베드 페이지는 빌드 시점에 주입된 설정값으로 Firebase를 초기화합니다.
3. `Lessons` 컬렉션에서 강의 코드와 테스트 정보를 불러옵니다.
4. `Records` 컬렉션에 기존 제출 기록이 있으면 사용자 코드를 복원하고 마지막
   제출 점수와 제출 시간을 표시합니다.
5. 학습자가 제출하면 사용자 코드와 테스트 코드를 함께 컴파일하고 iframe에서
   실행합니다.
6. 실행 결과를 기반으로 점수, 제출 시간, 부분 점수 상태를 Firebase에 저장합니다.

## Firebase 컬렉션

커스터마이징된 흐름은 다음 컬렉션을 기준으로 동작합니다.

- `Lessons`: 강의 메타데이터, 시작 코드, 테스트 코드, 기대 출력, 부분 점수 규칙을
  저장합니다.
- `Records`: 사용자별 강의 진행 상태, 작성 코드, 제출 점수, 제출 시간, 획득 경험치를
  저장합니다.
- `Users`: 사용자 프로필과 과목별 누적 경험치를 저장합니다.

## Query Parameter

- `uid`: 학습자 id입니다.
- `courseId`: 과목 id입니다.
- `chapterId`: 챕터 id입니다.
- `lessonId`: 강의 id입니다.
- `gutter`: 에디터와 실행 화면 사이 splitter 조작 가능 여부를 제어합니다.
- 기존 DartPad parameter인 `theme`, `run`, `open_console`, `split`,
  gist/sample 관련 parameter도 유지합니다.

## 보안 및 운영 메모

- Firebase 프로젝트 설정은 `lib/microlearnable_config.dart`에서
  `String.fromEnvironment`로 읽습니다.
- Firebase 이메일/비밀번호 인증 값은 배포 설정으로만 주입하고 소스 코드에
  저장하지 않습니다.
- `.firebase/`는 Firebase CLI가 생성하는 상태 파일이므로 git 추적 대상에서
  제외합니다.
- Firebase API key 자체는 Firebase에서 비밀 값으로 취급되지는 않지만, 환경별
  배포를 깔끔하게 분리하기 위해 코드에서 제거했습니다.

## 유지보수 기준

- 원본 DartPad의 편집, 분석, 컴파일, 실행 흐름은 가능한 한 유지합니다.
- Microlearnable 전용 배포 설정은 `lib/microlearnable_config.dart`에 모읍니다.
- 채점 로직을 수정할 때는 출력 비교 기반 강의와 테스트 결과 기반 강의를 모두
  확인합니다.
- UI 리소스나 결과 다이얼로그를 변경할 때는 제출, 재제출, 정답, 오답, 로딩 상태를
  함께 확인합니다.
