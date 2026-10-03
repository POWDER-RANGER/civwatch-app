# CIVWATCH App

Multi-platform **client** for CIVINTELLIGENCE + Cell Titan (Flutter: Android, iOS, Windows, Linux).

> **Status:** scaffold + API wiring. Not a certified multi-platform release until CI builds pass.  
> **Network policy:** Titan access is **localhost / emulator only** until Titan has a token **and** TLS (or VPN). Do not point a physical phone at `http://<LAN-IP>:8000` on an open LAN.

## Pair with Titan v0.1.2+

```bash
# Terminal 1 — loopback only
cd civwatch-cell-titan
export TITAN_API_TOKEN=...   # optional on pure localhost
./launch.sh                  # HOST=127.0.0.1

# Terminal 2
cd civwatch-app
flutter create . --platforms=android,ios,windows,linux,macos
flutter pub get
flutter run -d windows   # or linux / chrome / android emulator
```

| Client | Titan URL |
|--------|-----------|
| Desktop | `http://127.0.0.1:8000` |
| Android emulator | `http://10.0.2.2:8000` |
| iOS simulator | `http://127.0.0.1:8000` |
| Physical phone | **Not supported** without HTTPS/VPN + token |

Settings stores the **API token** in platform secure storage (`flutter_secure_storage`), not SharedPreferences.

## CI

GitHub Actions: `flutter analyze` + `flutter test` after `flutter create` generates platform trees.

## License

MIT
