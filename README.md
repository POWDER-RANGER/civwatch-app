# CIVWATCH App

**Multi-platform client** for the CIVINTELLIGENCE system — one codebase for **Android, iOS, Windows, and Linux**.

Connects to:

| Backend | Role |
|---------|------|
| [Cell Titan](https://github.com/POWDER-RANGER/civwatch-cell-titan) | Defensive RF telemetry, WebSocket live stream, evidence chain |
| [CivilianIntelligence](https://github.com/POWDER-RANGER/CivilianIntelligence) `public/civint/*.json` | NWS alerts, federal awards, ALPR points |

Desks: **Veil**, **Cell Titan**, **Privacy (ALPR)**, **Finance (awards)**, **Alerts (NWS)**.

> Defensive only. Public-interest. Never targeting individuals.

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) **3.22+** (stable)
- Optional local Titan: `cd civwatch-cell-titan && ./launch.sh`

## Run

```bash
git clone https://github.com/POWDER-RANGER/civwatch-app.git
cd civwatch-app
flutter create . --platforms=android,ios,windows,linux,macos
flutter pub get

flutter run -d windows
flutter run -d linux
flutter run -d android
flutter run -d ios
```

### Endpoints (Settings in-app)

| Platform | Typical Titan URL |
|----------|-------------------|
| Desktop | `http://127.0.0.1:8000` |
| Android emulator | `http://10.0.2.2:8000` |
| iOS simulator | `http://127.0.0.1:8000` |
| Physical device | `http://<lan-ip>:8000` |

CIVINT default: `https://raw.githubusercontent.com/POWDER-RANGER/CivilianIntelligence/main/public/civint`

## Build release

```bash
flutter build apk --release
flutter build appbundle --release
flutter build ipa
flutter build windows --release
flutter build linux --release
```

## License

MIT
