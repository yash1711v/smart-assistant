# smartassistant

Flutter app with suggestions, chat, and synced chat history.

## Chat API configuration

The chat client is configurable with `--dart-define`, so you can point the app
at your own AI/chat backend without changing code.

```bash
flutter run \
  --dart-define=API_BASE_URL=https://your-api.example.com \
  --dart-define=API_CHAT_PATH=/chat \
  --dart-define=API_CHAT_HISTORY_PATH=/chat/history
```

If your API requires an auth token, pass it at launch time as well:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://your-api.example.com \
  --dart-define=API_AUTH_TOKEN='Bearer your-token'
```

Optional:

- `API_AUTH_HEADER` defaults to `Authorization`
- `API_SUGGESTIONS_PATH` defaults to `/suggestions`

## Chat API contract

`POST /chat` accepts:

```json
{
  "message": "Hello"
}
```

Supported reply shapes include plain text or JSON payloads such as:

```json
{
  "reply": "Hi, how can I help?"
}
```

or:

```json
{
  "data": {
    "reply": "Hi, how can I help?"
  }
}
```

`GET /chat/history` can return either a list directly or a wrapped list under
`data`, `messages`, or `history`. Each item should include `sender` or `role`,
`message` or `content`, and can optionally include `timestamp`.
