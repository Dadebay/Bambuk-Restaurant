# Release and operations guide

## Current status (2026-11-08)

The repository currently declares `2.0.4+14` and Android package `com.softpage.bamboo`. This is preparation work, not a new published version. Do not tag or upload an APK until the version/build number is advanced, a real-device smoke test passes, and the Play app-signing certificate is compared with the local release certificate. The existing local release APK is **unpublished**.

The Android release signing key is kept outside Git in the owner's `Project Keys/6.Bambuk` folder. The ignored `android/key.properties` references it. The project owner controls the keystore, passwords, Play Console, Firebase project, and backup/recovery process. Rotate a compromised upload key through Play Console; never copy the key or credentials into issues, CI logs, or documentation. CI runs debug builds and needs no signing credentials.

## Before release

1. Confirm the production API at `https://bambukresto.com.tm:4443`, Firebase project, and order/payment provider are healthy. The backend owner must confirm server deployment, health checks, backups, restore exercise, account recovery, and payment rollback procedures; this repository does not contain that operational information.
2. Verify app start, login and session restore, menu and language selection, cart, delivery/pickup, a single order submission, payment return/status, order history, map permission, notifications, offline behavior, and sign-out on real Android and iOS devices. Use an approved payment test environment; avoid live charges for a smoke test.
3. Review Play Data safety and iOS privacy declarations against account data, push tokens, location, and third-party map/geolocation requests. Validate accessibility and small-screen/large-text layouts on devices.
4. Advance `version:` in `pubspec.yaml` above the published Play version code. Run format, analysis, tests, Android release build, and iOS build. Confirm the release signing certificate, package ID, version name/code, and SHA-256 of the APK with Android build tools. Compare the signing certificate to Play Console's **app signing certificate**, not only its upload certificate.
5. Open a PR with changes, tests, release impact, and residual risks. Merge only after review and green CI. Tag the exact validated merge commit as `vX.Y.Z` and build the APK again from that commit. Publish a GitHub Release with notes, the APK and checksum only if direct installation and upgrade compatibility are verified. Test the public download link.

## Rollback

For a Play rollout, halt staged distribution in Play Console and ship a corrective build with a higher version code. For a direct APK release, remove the affected asset and mark the release as withdrawn; publish a corrected, higher-version APK. Restore server state only through the backend owner's documented backup procedure. Monitor order failures, payment mismatches, crashes, and support requests during rollout.

No App Store URL, backend deployment steps, backup date, secret rotation order, or successful device smoke test has been verified yet; record those with the relevant owner before claiming release readiness.
