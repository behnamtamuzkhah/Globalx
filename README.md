# GlobalX — Production-Ready Flutter Application

A cross-platform fintech application built with Flutter for Web, Android, and iOS from a **single codebase**.

## 🌍 About GlobalX

GlobalX helps users find the best international money transfer routes by comparing 30+ providers across 130+ currencies with real-time FX rates, zero hidden fees, and instant route comparison.

**Live Web App:** https://globalx2105.builtwithrocket.new

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Version | Download |
|------|---------|----------|
| Flutter SDK | ≥ 3.10.0 | https://flutter.dev/docs/get-started/install |
| Dart SDK | ≥ 3.0.0 | Included with Flutter |
| Android Studio | Latest | https://developer.android.com/studio |
| Xcode | ≥ 14.0 | Mac App Store (macOS only) |
| CocoaPods | Latest | `sudo gem install cocoapods` |

Verify your Flutter installation:
```bash
flutter doctor -v
```

---

## 🛠️ Installation & Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. iOS Pod Install (macOS only)
```bash
cd ios && pod install && cd ..
```

### 3. Run in Development
```bash
# Web (Chrome)
flutter run -d chrome

# Android (connected device or emulator)
flutter run -d android

# iOS (connected device or simulator — macOS only)
flutter run -d ios
```

---

## 📁 Project Structure

```
globalx/
├── android/                    # Android-specific configuration
│   ├── app/
│   │   ├── build.gradle.kts    # Android build config (minSdk 21, release AAB)
│   │   ├── proguard-rules.pro  # ProGuard rules for release builds
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/         # MainActivity
├── ios/                        # iOS-specific configuration
│   ├── Runner/
│   │   ├── Info.plist          # App metadata, permissions, orientations
│   │   └── AppDelegate.swift
│   ├── Podfile                 # CocoaPods dependencies (iOS 13.0+)
│   └── Runner.xcworkspace      # Open this in Xcode (NOT .xcodeproj)
├── web/
│   ├── index.html              # SEO-optimized entry point with OG/Twitter meta
│   ├── manifest.json           # PWA manifest with GlobalX branding
│   └── favicon.png
├── lib/
│   ├── main.dart               # App entry point
│   ├── core/
│   │   └── app_export.dart     # Centralized exports
│   ├── data/
│   │   ├── currencies_data.dart    # 130+ currencies dataset
│   │   ├── providers_data.dart     # 30+ provider definitions
│   │   ├── fx_rates_service.dart   # Live FX rate fetching
│   │   └── route_engine.dart       # Route comparison logic
│   ├── presentation/
│   │   ├── home_screen/            # Dashboard with currency converter
│   │   ├── route_comparison_screen/ # Provider comparison
│   │   ├── route_detail_screen/    # Detailed route breakdown
│   │   ├── transfer_history_screen/ # Transfer history & stats
│   │   ├── settings_screen/        # User settings & preferences
│   │   └── edit_profile_screen/    # KYC profile editing
│   ├── routes/
│   │   └── app_routes.dart         # Named route definitions
│   ├── services/
│   │   └── affiliate_service.dart  # Provider affiliate links
│   ├── theme/
│   │   └── app_theme.dart          # Light/dark theme config
│   └── widgets/                    # Reusable UI components
├── assets/
│   └── images/                     # App images and SVGs
├── pubspec.yaml                    # Dependencies and metadata
└── README.md
```

---

## 🏗️ Production Build Commands

### 🌐 Web (Netlify / Vercel)

```bash
flutter build web --release --web-renderer canvaskit
```

Output is generated at: `build/web/`

**Deploy to Netlify:**
1. Run the build command above
2. Drag & drop the `build/web/` folder to https://app.netlify.com/drop
   — OR —
3. Connect your Git repository and set:
   - **Build command:** `flutter build web --release`
   - **Publish directory:** `build/web`

**Deploy to Vercel:**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy from build/web
vercel build/web --prod
```

---

### 🤖 Android APK (Direct Install)

```bash
# Debug APK
flutter build apk --debug

# Release APK (single universal APK)
flutter build apk --release

# Split APKs by ABI (smaller file sizes — recommended)
flutter build apk --release --split-per-abi
```

Output locations:
- Universal: `build/app/outputs/flutter-apk/app-release.apk`
- Split: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

---

### 📦 Android AAB (Google Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

> **Note:** For production Play Store releases, configure a signing keystore:
> ```bash
> keytool -genkey -v -keystore globalx-release.jks \
>   -alias globalx -keyalg RSA -keysize 2048 -validity 10000
> ```
> Then update `android/app/build.gradle.kts` with your `signingConfigs.release`.

---

### 🍎 iOS (Xcode / TestFlight)

```bash
# Build iOS release (macOS + Xcode required)
flutter build ios --release
```

**TestFlight Submission Steps:**
1. Open `ios/Runner.xcworkspace` in Xcode (**not** `.xcodeproj`)
2. Set your **Team** under `Runner → Signing & Capabilities`
3. Set **Bundle Identifier** (e.g. `com.yourcompany.globalx`)
4. Select **Any iOS Device (arm64)** as the build target
5. Go to **Product → Archive**
6. In the Organizer, click **Distribute App → App Store Connect**
7. Follow the upload wizard to submit to TestFlight

> **Requirements:** Apple Developer Account ($99/year), valid provisioning profile and certificate.

---

## 🔑 Environment Variables

The app uses `String.fromEnvironment()` for all sensitive configuration. Pass them at build time:

```bash
# Web build with env vars
flutter build web --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key

# Android build with env vars
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

---

## 🌐 Supported Platforms

| Platform | Status | Build Command |
|----------|--------|---------------|
| Web | ✅ Production Ready | `flutter build web --release` |
| Android APK | ✅ Production Ready | `flutter build apk --release` |
| Android AAB | ✅ Production Ready | `flutter build appbundle --release` |
| iOS | ✅ TestFlight Ready | `flutter build ios --release` |

---

## 🧩 Key Features

- **Dashboard** — Currency conversion with live FX rates
- **Route Comparison** — Compare 30+ providers side-by-side
- **Route Detail** — Fee breakdown, delivery timeline, step-by-step flow
- **Transfer History** — Saved transfers with search and stats
- **Settings** — Preferences, notifications, rate alerts
- **Edit Profile** — Full KYC profile with address, ID type, DOB

---

## 🎨 Tech Stack

| Category | Package | Purpose |
|----------|---------|---------|
| UI Framework | Flutter 3.x | Cross-platform UI |
| Responsive | sizer ^2.0.15 | Adaptive layouts |
| HTTP Client | dio ^5.4.0 | API requests |
| Charts | fl_chart ^0.65.0 | Data visualization |
| Storage | shared_preferences ^2.2.2 | Local persistence |
| Images | cached_network_image ^3.3.1 | Network image caching |
| Fonts | google_fonts ^6.1.0 | Inter typography |
| SVG | flutter_svg ^2.0.9 | Vector graphics |
| Links | url_launcher ^6.2.5 | External URLs |

---

## 🚀 Quick Start (TL;DR)

```bash
# 1. Install deps
flutter pub get

# 2. Run on web
flutter run -d chrome

# 3. Build for production web
flutter build web --release

# 4. Build Android APK
flutter build apk --release --split-per-abi

# 5. Build iOS (macOS only)
flutter build ios --release
```

---

## 🙏 Acknowledgments

- Built with [Rocket.new](https://rocket.new)
- Powered by [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- Styled with Material Design 3

Built with ❤️ on Rocket.new
