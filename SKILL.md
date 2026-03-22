# notepad

사용 도구: launch_app, read_app_state, send_app_command, terminate_app, discover_app_commands

로컬 메모장 앱(Note Pad)을 제어하고 실시간으로 내용을 업데이트하거나 편집 모드를 설정하는 스킬이다. 범용적인 앱 제어(실행, 복구)는 `app_control` 스킬의 규칙을 따른다.

사용 규칙:

- **메모장 제어 프로세스**:
  1. 앱이 실행 중인지 `discover_app_commands(appId: "notepad")`로 먼저 확인한다.
  2. 앱이 꺼져 있다면 `launch_app(appName: "notepad")`로 메모장을 먼저 띄운다.
     - 내용이 미리 필요하면 `env` 파라미터에 `NOTEPAD_CONTENT: "내용"` 형태로 주입한다.
  3. 사용자가 메모장 내용을 물어보거나 수동으로 수정한 내용을 확인해야 할 때는 `read_app_state` 도구를 사용하여 `"notepad"`의 상태를 읽어온다.
  4. 이미 메모장이 열려 있는 상태에서 내용을 제어(텍스트 업데이트, 읽기 전용 설정, 마크다운 기반 리치 텍스트 설정 등)할 때는 `send_app_command`를 통해 전달한다.
     - `SET_RICH_MODE`를 `true`로 설정하면 작성한 텍스트가 마크다운(Markdown)으로 렌더링되어 표시된다. 다시 `false`로 설정하면 평문(Plain Text) 편집 모드로 돌아온다.
     - 명령어 구조를 모를 때는 `discover_app_commands` 결과값을 참고한다.

우선순위:
1. `discover_app_commands`로 메모장 존재 및 명령어 확인
2. (앱이 꺼져있을 때만) `launch_app` 실행
3. `read_app_state`로 최신 내용 확인
4. `send_app_command`로 내용이나 설정 원격 제어
5. 도구 실패 시(연결 오류 등) `launch_app`으로 자동 복구 시도
