# ARI Plugin Skill: ARINotePad (Note Pad)

## Overview
`notepad`는 심플한 노트패드 번들로, 마크다운(Markdown) 문법 지원 및 읽기 전용/편집 모드 전환 기능을 제공합니다. 사용자의 요청을 텍스트로 기록하거나 원격으로 보여주고 싶을 때 사용합니다.

### App ID
`notepad`

---

## Commands

### 1. Content Management (내용 제어)
- `UPDATE`: 메모장의 전체 텍스트를 새로운 내용으로 교체합니다.
  - Params: `text` (String)

### 2. View Mode (뷰어 설정)
- `SET_RICH_MODE`: 작성한 텍스트가 마크다운(Markdown)으로 렌더링되도록 설정하거나 일반 텍스트 모드로 전환합니다.
  - Params: `isRichText` (`true`: 마크다운 렌더링, `false`: 일반 텍스트)

### 3. Edit Mode (편집 차단)
- `SET_EDIT_MODE`: 읽기 전용 또는 편집 가능 상태를 원격으로 설정합니다.
  - Params: `isReadOnly` (`true`: 사용자가 수정 불가, `false`: 편집 가능)

---

## Writing Rules
1. **실시간 정보 확인**: 사용자가 메모장 내용을 물어보거나 수동 수정 사항을 확인할 때는 `read_app_state`를 주기적으로 활용하세요.
2. **시각적 효과 개선**: 내용이 잘 정리된 마크다운 결과물을 보여주고 싶다면 `SET_RICH_MODE`를 `true`로 먼저 보낸 뒤 `UPDATE`를 수행하세요.
3. **앱 시작 시 내용 주입**: `launch_app(appName: "notepad")` 호출 시 `env` 파라미터에 `{"NOTEPAD_CONTENT": "초기 내용"}`을 주입하여 미리 채워진 상태로 띄울 수 있습니다.
4. **편집 차단**: 에이전트가 작업 중일 때 사용자의 실수를 방지하고 싶다면 `SET_EDIT_MODE`(`isReadOnly: true`)를 활용해 일시적으로 편집을 막으세요.

---

## Examples

### 메모장 텍스트 업데이트
```json
{
  "command": "UPDATE",
  "params": {
    "text": "# 오늘의 할 일\n1. 아침 운동 하기\n2. 모바일 앱 기획안 검토\n3. 회의 자료 준비"
  }
}
```

### 마크다운 뷰어 모드로 전환
```json
{
  "command": "SET_RICH_MODE",
  "params": {
    "isRichText": true
  }
}
```

### 읽기 전용 모드로 설정
```json
{
  "command": "SET_EDIT_MODE",
  "params": {
    "isReadOnly": true
  }
}
```
