# FamPay Contextual Cards Assignment

A Flutter application that displays contextual cards fetched from the FamPay API, implementing all required features including deeplink handling, card dismissal, pull-to-refresh, and responsive design.

## 📹 Demo

- App walkthrough video (HC1/HC3/HC5/HC6/HC9, pull-to-refresh, deeplinks, HC3 long-press actions):
  - Google Drive link: <ADD_LINK_HERE>
  - Backup GIF (short preview): `assets/demo/preview.gif`
- APK for reviewers: `build/app/outputs/flutter-apk/app-release.apk`

> Tip: If running locally, follow Setup below. The video demonstrates: loading → list render → deeplink taps → HC3 long-press (remind later / dismiss now) → relaunch behavior → pull-to-refresh → HC6 horizontal scroll → HC9 dynamic width.

## 🚀 Features Implemented

### ✅ Core Requirements
- **Deeplink Handling**: All card URLs, CTAs, and formatted text entities are clickable
- **Long Press Actions**: HC3 cards support long press with slide animation and action buttons
  - "Remind Later": Temporarily dismisses card until next app start
  - "Dismiss Now": Permanently removes card
- **Pull to Refresh**: Swipe down to refresh cards
- **Card Persistence**: Uses SharedPreferences for dismissed card storage
- **Enhanced Error/Loading States**: Beautiful UI feedback for all states

### ✅ Card Types Supported
- **HC1**: Small Display Cards with icons and text
- **HC3**: Big Display Cards with background images and CTAs
- **HC5**: Image Cards (dynamic height supported via group height)
- **HC6**: Small Cards with Arrow (icon left, text center, arrow pinned right)
- **HC9**: Dynamic Width Cards (width by aspect ratio, height by group)

### ✅ Advanced Features
- **Formatted Text Support**: Rich text with entities, colors, fonts, and clickable URLs
- **Asset & External Images**: Support for both local assets and network images
- **Gradient Backgrounds**: Linear gradients with custom angles
- **Responsive Design**: Adapts to different screen sizes (phone, tablet)
- **URL Launcher Integration**: Opens external links and deep links
- **Card Filtering**: Automatically filters dismissed cards

## 🏗️ Architecture

### Clean Architecture Pattern
```
lib/
├── core/
│   ├── api/           # API client (Dio)
│   ├── models/        # Data models
│   ├── repository/    # Data repository
│   ├── services/      # Business services
│   └── utils/         # Utility functions
├── features/
│   └── cards/
│       ├── bloc/      # State management (BLoC)
│       ├── view/      # UI screens
│       └── widgets/   # Reusable components
└── main.dart
```

### State Management
- **BLoC Pattern**: Clean separation of business logic and UI
- **Events**: FetchCardsEvent, RefreshCardsEvent, DismissCardEvent, RemindLaterCardEvent
- **States**: CardsInitial, CardsLoading, CardsLoaded, CardsError

### Data Flow
1. **Repository** fetches data from API
2. **BLoC** processes events and manages state
3. **UI** reacts to state changes
4. **Services** handle side effects (URL launching, persistence)

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.5.4 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fampay_assignment
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Dependencies
- `flutter_bloc`: State management
- `dio`: HTTP client
- `cached_network_image`: Image caching
- `url_launcher`: Deep link handling
- `shared_preferences`: Local storage
- `google_fonts`: Typography
- `shimmer`: Loading animations

## 📱 Usage

### Card Interactions
- **Tap**: Opens card URL or CTA URL
- **Long Press (HC3)**: Shows action buttons with slide animation (left-only slide; right edge fixed)
- **Pull Down**: Refreshes all cards
- **Swipe**: Horizontal scrolling for scrollable card groups

### Card Dismissal
- **Remind Later**: Card disappears until next app launch
- **Dismiss Now**: Card is permanently removed
- **Reset**: Clear app data to restore all cards

## 🎨 Design Implementation

### Responsive Design
- **Small Screens** (< 400px): Compact layout with smaller fonts
- **Medium Screens** (400-600px): Standard layout
- **Large Screens** (> 600px): Expanded layout with larger fonts

### Card Styling
- **HC1**: Circular icons, colored backgrounds, clean typography
- **HC3**: Large icon/gradient, prominent CTA, Figma-aligned spacing
- **HC5**: Image-focused with minimal text; dynamic height
- **HC6**: Icon left, underlined text, black arrow pinned right
- **HC9**: Dynamic width based on image aspect ratio

## 🔧 API Integration

### Endpoint
```
GET https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage
```

### Response Structure
- **Card Groups**: Array of card collections
- **Cards**: Individual card objects with metadata
- **Formatted Text**: Rich text with entities and styling
- **Images**: Asset or external image references
- **CTAs**: Call-to-action buttons with URLs

## 🧪 Testing

### Manual Testing
1. **Card Display**: Verify all card types render correctly
2. **Deeplinks**: Test URL opening for cards, CTAs, and entities
3. **Long Press**: Test HC3 action buttons and animations
4. **Dismissal**: Test "remind later" vs "dismiss now" behavior
5. **Refresh**: Test pull-to-refresh functionality
6. **Responsive**: Test on different screen sizes

### Edge Cases Handled
- **Empty States**: No cards, loading, error states
- **Network Issues**: Graceful error handling
- **Invalid URLs**: Fallback behavior
- **Missing Images**: Placeholder images
- **Malformed Data**: Safe parsing with defaults

## 📊 Performance Optimizations

- **Image Caching**: CachedNetworkImage for efficient loading
- **Lazy Loading**: Cards load as needed
- **Memory Management**: Proper disposal of controllers
- **State Persistence**: Efficient local storage

## 🚀 Submission

- **Repository**: Clean commit history and README with setup instructions
- **APK**: Include `app-release.apk` inside the repo under `build/app/outputs/flutter-apk/`
- **Recordings**: Add a short screen recording (or the Demo link above)
- **What reviewers will see**:
  - API-only rendering (no hardcoded user-facing strings)
  - Deeplinks on cards/CTAs/entities
  - HC3 long-press actions with persistence
  - Pull-to-refresh, loading/error/empty states
  - HC9 dynamic width; HC5 dynamic height; HC6 arrow pinned right

## 📝 Code Quality

### Best Practices
- **Clean Code**: Readable, maintainable code structure
- **Error Handling**: Comprehensive error management
- **Documentation**: Inline comments for complex logic
- **Type Safety**: Strong typing throughout
- **Separation of Concerns**: Clear architectural boundaries

### Git Practices
- **Clean Commits**: Descriptive commit messages
- **Feature Branches**: Organized development workflow
- **Code Reviews**: Quality assurance process

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is part of the FamPay assignment and is for evaluation purposes only.

---

**Built with ❤️ using Flutter**