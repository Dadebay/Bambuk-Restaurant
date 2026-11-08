# Release and operations guide

## Current status (2026-11-08)

Version `2.0.5+15` (`com.softpage.bamboo`) was built from merge commit `127bcdf4082a04b639e22f872640c735367fa836` and published as a [GitHub pre-release](https://github.com/Dadebay/Bambuk-Restaurant/releases/tag/v2.0.5). Its signed [APK](https://github.com/Dadebay/Bambuk-Restaurant/releases/download/v2.0.5/Bamboo-Restaurant-v2.0.5.apk) has SHA-256 `ede35391b559b1b79d908ef9293a4d478c46d5432ff31f48f46dc951a7063839`; the [checksum file](https://github.com/Dadebay/Bambuk-Restaurant/releases/download/v2.0.5/SHA256SUMS.txt) is attached to the Release. The previous local `2.0.4+14` APK was not published.

The release build, package/version/signature inspection, Flutter tests, analysis without warnings or errors, and main-branch CI passed. No real Android device was connected for installation or order/payment tests. The Play Console app-signing certificate was not available for comparison, so an in-place update of the Play-installed app is unverified. Keep this build marked as a pre-release until those checks pass.

This GitHub repository is private. A Release here is visible only to people with repository access; a public download for customers requires an approved public distribution location. Do not change repository visibility solely to distribute the APK without reviewing the source and its history for private material.

The Android release signing key is kept outside Git in the owner's `Project Keys/6.Bambuk` folder. The ignored `android/key.properties` references it. The project owner controls the keystore, passwords, Play Console, Firebase project, and backup/recovery process. Rotate a compromised upload key through Play Console; never copy the key or credentials into issues, CI logs, or documentation. CI runs debug builds and needs no signing credentials.

## Before release

1. Confirm the production API at `https://bambukresto.com.tm:4443`, Firebase project, and order/payment provider are healthy. The backend owner must confirm server deployment, health checks, backups, restore exercise, account recovery, and payment rollback procedures; this repository does not contain that operational information.
2. Verify app start, login and session restore, menu and language selection, cart, delivery/pickup, a single order submission, payment return/status, order history, map permission, notifications, offline behavior, and sign-out on real Android and iOS devices. Use an approved payment test environment; avoid live charges for a smoke test.
3. Review Play Data safety and iOS privacy declarations against account data, push tokens, location, and third-party map/geolocation requests. Validate accessibility and small-screen/large-text layouts on devices.
4. Advance `version:` in `pubspec.yaml` above the published Play version code. Run format, analysis, tests, Android release build, and iOS build. Confirm the release signing certificate, package ID, version name/code, and SHA-256 of the APK with Android build tools. Compare the signing certificate to Play Console's **app signing certificate**, not only its upload certificate.
5. Open a PR with changes, tests, release impact, and residual risks. Merge after review and green CI. Tag the exact validated merge commit as `vX.Y.Z` and build the APK again from that commit. A build without real-device and Play signature checks must remain a pre-release with those limits stated. Verify installation and upgrade compatibility before promoting it to a production release. Test any public download link from an account without repository access.

## Rollback

For a Play rollout, halt staged distribution in Play Console and ship a corrective build with a higher version code. For a direct APK release, remove the affected asset and mark the release as withdrawn; publish a corrected, higher-version APK. Restore server state only through the backend owner's documented backup procedure. Monitor order failures, payment mismatches, crashes, and support requests during rollout.

No App Store URL, backend deployment steps, backup date, secret rotation order, or successful device smoke test has been verified yet; record those with the relevant owner before claiming release readiness.
