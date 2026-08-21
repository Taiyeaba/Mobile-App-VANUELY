<div align="center">

# 💎 VENUELY
### *Premium Mobile Application for Event Venue Discovery & Booking*

[![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B.svg?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Provider](https://img.shields.io/badge/Provider-6.1.2-purple.svg?style=for-the-badge)](https://pub.dev/packages/provider)
[![SharedPreferences](https://img.shields.io/badge/Storage-SharedPreferences-gold.svg?style=for-the-badge)](https://pub.dev/packages/shared_preferences)
[![Flutter Analyze](https://img.shields.io/badge/Flutter_Analyze-0_Errors_Pass-success.svg?style=for-the-badge&logo=checkmarx&logoColor=white)](https://flutter.dev)

<p align="center">
  A state-of-the-art Flutter mobile application featuring dark luxury aesthetics, gold accents, interactive 360° virtual venue tours, 3-venue side-by-side comparison, dynamic 5-star user review system, and bank-grade SSL payment gateway simulation.
</p>

</div>

---

## 🎓 Academic Project Information

| Parameter | Project & Student Detail |
| :--- | :--- |
| **Application Name** | **VENUELY** (Mobile Event Venue Booking) |
| **Student Name** | **Taiyeaba Shams** |
| **Student ID** | **232-134-012** |
| **Program & Batch** | **B.Sc. in Software Engineering (SWE)** — *5th Batch* |
| **Course Title** | **Mobile Application Development** |
| **Course Instructor** | **Zia Khan** (`developer.ziakhan@gmail.com`) |

---

## ✨ Key Feature Modules

### 1. 📱 Onboarding & Authentication Gateway
- **Animated Splash Screen**: Brand scaling & fade transitions with Venuely logo.
- **3-Screen Onboarding Flow**: Feature slides with persistent completion tracking.
- **Local Auth UI**: Login, Sign Up, and Guest mode options with strict regex validation.

### 2. 🏠 Luxury Home Dashboard & Content Hierarchy
- **Featured Venues Carousel**: Main premium highlighted carousel with left/right scroll controls.
- **Exclusive Booking VIP Collection**: Dedicated VIP collection (*VIP Access*, *Exclusive*, *Limited Availability*) with gold badges and direct "View & Book" CTAs.
- **Compact Event Category Selector**: Top category chips (`✨ All`, `💍 Wedding`, `🎂 Birthday`, `💼 Corporate`) with a **`⋯ More`** control that opens an interactive **Event Categories Bottom Sheet**.
- **Special Weekend Offer**: Compact gold gradient promotional card featuring instant deposit discounts.
- **Popular Spaces & Recommended For You**: Curated recommendations and vertical venue listings.

### 3. 🔍 Advanced Search, Filters & Venue Comparison
- **Real-Time Search & Filtering**: Instant search by venue name, location, or occasion type.
- **Advanced Filter Modal**: Location dropdowns, Sort By options, and Max Price slider (`৳30,000` – `৳350,000`).
- **Venue Comparison Feature**: Compare up to 3 selected venues side-by-side (Price, Guest Capacity, Rating, Facilities, Valet Parking, Air Conditioning).

### 4. 🏰 Venue Details & Multi-Media Viewer
- **Multi-Photo Gallery Carousel**: Page indicator chips (`1/8`) and 4K photo viewer.
- **Fullscreen HD Photo Viewer**: Swipeable, pinch-to-zoom 4K gallery viewer with photo counter.
- **360° Virtual Tour & Distance Map Modals**: Interactive panorama view and travel distance breakdown from key Dhaka hubs.

### 5. ⭐️ User Review & Rating System
- **Dynamic Rating Breakdown**: Overall rating (e.g. `4.9 ★`), total review count, and 5-star percentage progress bars (5★ 82%, 4★ 12%, 3★ 4%, 2★ 1%, 1★ 1%).
- **Interactive "Write a Review" Modal**: 1-to-5 star rating selector, minimum 10-character review comment validation, and submit button.
- **Local State Persistence**: Submitted reviews immediately update the venue's average rating and star breakdown, persisting across app restarts using `SharedPreferences`.

### 6. 📅 6-Step Booking Flow, Promo Code & Payment Gateway
- **6-Step Guided Booking**:
  1. *Event Type Selection*
  2. *Calendar Date Picker*
  3. *Time Slot Picker* (`10:00 AM`, `12:00 PM`, `04:00 PM`, etc.)
  4. *Guest Capacity Counter*
  5. *Host Contact Form*
  6. *Booking Summary & Payment Channel Selection*
- **Promo / Coupon Code Engine**: Enter `VENUELY15` or `GOLD2026` for an instant 15% deposit discount.
- **256-Bit Bank-Grade SSL Payment Gateway Sheet**: Select payment channels (**bKash**, **Nagad**, **Rocket**, **Credit/Debit Card**), enter account & security OTP, and complete payment with realistic loading spinners.
- **Digital Receipt PDF Modal**: Verified SSL encrypted voucher generator with transaction reference ID.

### 7. 🔔 Notifications, Favorites & Theme Preferences
- **Notifications Screen**: Top bar notification bell with unread badge counter, notification items, and mark-all-as-read controls.
- **Saved Favorites Tab**: Persistent bookmarking powered by `FavoriteProvider`.
- **My Bookings History**: Active and cancelled booking cards with status tags.
- **Dark / Light Theme Toggle**: Persistent theme mode switching via `ThemeProvider`.

---

## 🛠️ Software Architecture & Tech Stack

```
lib/
├── data/              # Mock dataset (dummyVenues, exclusiveVenues, dummyReviews)
├── models/            # Data models (Venue, Booking, Review, UserProfile)
├── providers/         # Provider State Management
│   ├── theme_provider.dart
│   ├── venue_provider.dart
│   ├── booking_provider.dart
│   ├── favorite_provider.dart
│   ├── profile_provider.dart
│   └── review_provider.dart
├── services/          # Storage Service (SharedPreferences Local Storage Engine)
├── utils/             # App Colors, Theme Tokens, Constants, Form Validators
├── widgets/           # Modular Reusable UI Components
│   ├── custom_app_bar.dart
│   ├── custom_drawer.dart
│   ├── category_chip.dart
│   ├── venue_card.dart
│   ├── featured_venue_card.dart
│   ├── exclusive_venue_card.dart
│   ├── payment_gateway_dialog.dart
│   └── ...
└── screens/           # Application Screen Layouts
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    ├── login_screen.dart
    ├── home_screen.dart
    ├── venue_details_screen.dart
    ├── venue_comparison_screen.dart
    ├── fullscreen_gallery_screen.dart
    ├── notifications_screen.dart
    └── booking/
```

| Layer | Implementation |
| :--- | :--- |
| **Framework** | Flutter 3.44+ / Dart 3.12+ |
| **Design Language** | Dark Luxury Theme, Gold Accents (`#D4AF37`), Glassmorphism |
| **State Management** | Provider (`ChangeNotifier`, `MultiProvider`) |
| **Storage Engine** | SharedPreferences (Theme, Favorites, User Profile, Submitted Reviews) |
| **Code Quality** | `flutter analyze` verified with 0 Errors & 0 Warnings |

---

## 🚀 Execution & Verification

### 1. Setup Repository
```bash
git clone https://github.com/taiyeaba-shams/venuely-app.git
cd mbl-app-dev
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Code Quality
```bash
flutter analyze
```

### 4. Launch Application
```bash
flutter run
```

---

<div align="center">

**Developed for Academic Presentation — B.Sc. in Software Engineering**  
*All Rights Reserved © 2026 Taiyeaba Shams*

</div>
