# CIVWATCH App

**Multi-platform operator client for the CIVWATCH ecosystem.**

Flutter client for **CIVINTELLIGENCE**, **Watchtower**, and **Cell Titan**, targeting Android, iOS, Windows, and Linux.

> **Status:** integration staged; release acceptance requires green analysis, tests, and target builds.

## Architecture

| Service | Role | Default/example |
|---|---|---|
| CivilianIntelligence | Unified public-facing hub | Configured per deployment |
| Watchtower | Map/oversight API | http://127.0.0.1:3000 |
| Cell Titan | RF telemetry/evidence API | http://127.0.0.1:8000 |
| CIVINT snapshots | Public JSON feeds | CivilianIntelligence public/civint |

Titan bearer credentials are stored with flutter_secure_storage.

## Quick start

### Start Cell Titan

~~~bash
cd civwatch-cell-titan
export TITAN_API_TOKEN="$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')"
./launch.sh
~~~

### Start Flutter

~~~bash
cd civwatch-app
flutter create . --platforms=android,ios,windows,linux,macos
flutter pub get
flutter run -d linux
~~~

## Endpoint policy

| Runtime | Example |
|---|---|
| Desktop | http://127.0.0.1:8000 |
| Android emulator | http://10.0.2.2:8000 |
| iOS simulator | http://127.0.0.1:8000 |
| Physical phone | **HTTPS/VPN only** |

The client rejects remote HTTP service URLs. HTTP is accepted only for localhost/emulator endpoints.

## Settings

Configure Titan, Watchtower, and CIVINT endpoints from **Settings**.

Titan credentials are not stored in ordinary preferences and are never placed in the WebSocket URL.

## Live Titan connection

The client connects to /ws/live and performs the Titan auth handshake with the first JSON message when authentication is required.

## Integration

The client is an operator surface, not a new system of record:

- CivilianIntelligence owns the unified public-facing contract.
- Watchtower owns map/report service behavior.
- Cell Titan owns RF telemetry and evidence.

See the [cross-repo integration contract](https://github.com/POWDER-RANGER/CivilianIntelligence/blob/main/docs/CROSS_REPO_INTEGRATION.md).

## Development notes

- Linux secure storage requires libsecret.
- Android cleartext networking is restricted to local/emulator endpoints.
- iOS localhost development may require the repository ATS snippet after flutter create.

## Related repositories

- [CivilianIntelligence](https://github.com/POWDER-RANGER/CivilianIntelligence)
- [Watchtower](https://github.com/POWDER-RANGER/civwatch-watchtower)
- [Cell Titan](https://github.com/POWDER-RANGER/civwatch-cell-titan)
- [CIVWATCH](https://github.com/POWDER-RANGER/CIVWATCH)

## License

MIT
