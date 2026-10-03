# Android platform tree

Do **not** commit a stub `AndroidManifest.xml` — `flutter create .` generates a full one with activities.

After `flutter create . --platforms=android`:

1. Keep `app/src/main/res/xml/network_security_config.xml` (loopback/emulator cleartext only).
2. Add to the generated `<application>` tag:
   `android:networkSecurityConfig="@xml/network_security_config"`

CI patches the generated manifest and asserts `activity` + `networkSecurityConfig` are present.
