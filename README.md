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


---

## Public platform status — October 2026

**CIVINTELLIGENCE is live on the public web and its REST/API surface is active.**

**Public site:** https://civintelligence.onrender.com

The web platform is now the working reference implementation for the CIVWATCH ecosystem: the core application, public-data surfaces, evidence/provenance model, specialized pillars, and integration boundaries are being exercised through the deployed CIVINTELLIGENCE service.

### Applications are next

With the web application and REST contracts now active, the remaining client work is primarily **productization and platform packaging**, not rebuilding the intelligence platform from scratch. Native applications for the major target platforms are planned and will be coming soon.

The application layer can consume the same stable contracts already used by the web experience:

- **Android**
- **iOS**
- **Windows**
- **Linux**
- additional platform clients as the shared API contract matures

The existing Flutter client and service boundaries give the ecosystem a head start. Mobile/desktop applications can progressively adopt the established authentication, API, provenance, map, evidence, and desk contracts rather than duplicating backend intelligence.

### How quickly this came together

The current milestone is notable because the ecosystem moved from a multi-repository architecture and integration plan to a functioning public platform in a short development window. The difficult architectural work — ownership boundaries, public-data ingestion, REST contracts, evidence/provenance rules, Watchtower/Cell Titan integration, and the user-facing desk model — is already substantially established.

That means the next step should be treated as **client delivery on top of an operating platform**. The web application is the reference surface; native clients become additional presentation and interaction layers over the same CIVINTELLIGENCE contracts.

> **Build once at the platform layer. Deliver many clients at the edge.**

### Ecosystem rule

CIVINTELLIGENCE remains the system of record. Specialized repositories retain clear ownership of their domains, while clients consume stable public/service contracts. Legacy and predecessor repositories remain valuable migration/reference material but are not silently represented as unified production capabilities.

**Status discipline:** live means exposed and usable; available means implemented and integrated; in progress means actively being built; planned means not yet shipped. No synthetic or unavailable source is represented as live evidence.
