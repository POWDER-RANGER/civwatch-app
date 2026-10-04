# CIVWATCH App

Multi-platform **client** for CIVINTELLIGENCE + Cell Titan (Flutter: Android, iOS, Windows, Linux).

> **Status:** scaffold until GitHub Actions builds are green.  
> **Network policy:** Titan is **localhost / emulator only** until token **and** TLS or VPN. No open-LAN phone access.

## Pair with Titan ≥ 0.1.2

```bash
cd civwatch-cell-titan
export TITAN_API_TOKEN="$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')"
./launch.sh   # 127.0.0.1 only

cd civwatch-app
flutter create . --platforms=android,ios,windows,linux,macos
flutter pub get
flutter run -d linux   # or windows / android emulator
```

| Client | Titan URL |
|--------|-----------|
| Desktop | `http://127.0.0.1:8000` |
| Android emulator | `http://10.0.2.2:8000` |
| iOS simulator | `http://127.0.0.1:8000` |
| Physical phone | **Unsupported** without HTTPS/VPN |

- API token → **Settings** → stored with `flutter_secure_storage`
- WebSocket auth → first JSON message `{"type":"auth","token":"..."}` (never in the URL)
- Android cleartext allowed **only** for `127.0.0.1`, `localhost`, `10.0.2.2` (see `network_security_config.xml`)
- iOS: merge `ios/Runner/Info.plist.snippet` ATS exceptions for localhost after `flutter create`
- **Linux:** install `libsecret-1` for secure storage (`sudo apt install libsecret-1-0 libsecret-1-dev`)

## Integration

The app treats CivilianIntelligence as the hub, Watchtower as the map/oversight pillar, and Cell Titan as the defensive RF pillar. Service endpoints are stored locally; HTTP is accepted only for localhost/emulator endpoints, while remote endpoints must use HTTPS.

## CI

Workflow runs `flutter create .`, then analyze, test, and release builds for Linux, Windows, and Android.

## License

MIT
