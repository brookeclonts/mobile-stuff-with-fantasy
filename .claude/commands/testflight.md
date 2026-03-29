# /testflight - Build and upload to TestFlight

Build the Flutter iOS app and upload to App Store Connect for TestFlight distribution.

## Usage

```
/testflight              # Build iOS, auto-bump build number, upload
```

## What to do

1. **Read the current version** from `pubspec.yaml` (the `version:` line, format `X.Y.Z+BUILD`).

2. **Determine the next build number** by incrementing the current build number (the number after `+`) by 1.

3. **Update pubspec.yaml** with the new build number.

4. **Build the IPA** by running:
   ```bash
   cd /Users/seth/repositories/swf-app && \
   flutter build ipa --release \
     --build-number=<NEW_BUILD_NUMBER> \
     --export-options-plist=ios/ExportOptions.plist
   ```
   Timeout: 5 minutes. If the build fails, show the error and stop.
   This is the provisional build number for the archive. App Store Connect may still auto-increment the exported IPA build number if needed.

5. **Upload to App Store Connect** by running:
   ```bash
   xcrun altool --upload-app --type ios \
     -f /Users/seth/repositories/swf-app/build/ios/ipa/swf_app.ipa \
     --api-key JJZ779Q67V \
     --api-issuer 119abbe0-5bda-4086-aa55-fd7781f0b3b3 \
     --p8-file-path ~/.private_keys/AuthKey_JJZ779Q67V.p8
   ```
   Timeout: 5 minutes. Use the Second Star App Store Connect key for this app.

6. **Capture the delivery UUID** from the successful upload output, then fetch the final processed build metadata:
   ```bash
   xcrun altool --build-status \
     --delivery-id <DELIVERY_UUID> \
     --output-format json \
     --api-key JJZ779Q67V \
     --api-issuer 119abbe0-5bda-4086-aa55-fd7781f0b3b3
   ```

7. **Sync `pubspec.yaml` to the final uploaded build number** from `app-store-attributes.version`.
   If App Store Connect auto-incremented the uploaded build number, update `pubspec.yaml` so the repo matches TestFlight before committing.

8. **Report the result** — version number, final uploaded build number, delivery UUID, and whether the upload succeeded.

## Configuration

- **Bundle ID:** `com.secondstar.stuffwithfantasy`
- **Team ID:** `697ZACV5N9`
- **App Name:** StuffWithFantasy
- **ExportOptions.plist:** `ios/ExportOptions.plist`
- **API Key ID:** `JJZ779Q67V`
- **API Issuer ID:** `119abbe0-5bda-4086-aa55-fd7781f0b3b3`
- **API Key Path:** `~/.private_keys/AuthKey_JJZ779Q67V.p8`
- **pubspec.yaml:** `pubspec.yaml`
- **Auto-manage build numbers:** enabled in `ios/ExportOptions.plist`

## Notes

- The `XLDQ97MTSN` key can authenticate, but it does not map to the `com.secondstar.stuffwithfantasy` app in App Store Connect.
- The `JJZ779Q67V` key is the verified working key for TestFlight uploads for this bundle ID.
- Keep `manageAppVersionAndBuildNumber` set to `true` so App Store Connect can auto-increment when needed.
- After upload, always sync `pubspec.yaml` to the final processed build number returned by `altool --build-status`.
