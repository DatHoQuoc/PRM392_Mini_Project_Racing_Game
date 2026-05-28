# Mini Racing Game – Flutter Project Architecture

## Project Overview

A Flutter mobile game simulating car racing with a betting system. The app runs in **landscape orientation only (812×375px)**. Add this to `AndroidManifest.xml` and `Info.plist` to lock orientation:

```dart
// main.dart — lock to landscape before runApp
SystemChrome.setPreferredOrientations([
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);
``` Players choose a track shape, select a car, place bets using a slider, watch the race with animated UI, and receive win/loss results. No database — all data is hardcoded or loaded from local JSON assets.

**Color Palette**
| Token | Hex | Usage |
|---|---|---|
| Primary Red | `#C33332` | Buttons, accents, active states |
| Sky Blue | `#87CEEB` | Backgrounds, track surfaces |
| Navy | `#000080` | Headers, navigation bar, text |
| Yellow | `#FFFF00` | Winner highlights, money indicators |

---

## Architecture: MVVM

```
lib/
├── main.dart
├── app/
│   └── app.dart                    # MaterialApp, routing, theme
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Color palette constants
│   │   ├── app_strings.dart        # All string literals
│   │   └── app_assets.dart         # Asset path constants (audio, images, JSON)
│   ├── enums/
│   │   ├── track_type.dart         # figure8, circle, square
│   │   └── race_state.dart         # idle, countdown, racing, finished
│   └── utils/
│       └── audio_manager.dart      # AudioPlayer wrapper for state-based audio
├── data/
│   ├── models/
│   │   ├── car_model.dart          # Car id, name, speed stats, asset path
│   │   ├── track_model.dart        # Track id, name, shape enum, audio key
│   │   └── race_result_model.dart  # Winner id, bets, payout delta
│   └── repositories/
│       └── game_repository.dart    # Loads cars.json & tracks.json from assets
├── viewmodels/
│   ├── auth_viewmodel.dart         # Login state (username hardcoded)
│   ├── home_viewmodel.dart         # Volume setting, wallet balance, logout
│   ├── track_viewmodel.dart        # Selected track state
│   ├── bet_viewmodel.dart          # Selected car, slider bet amount, validation
│   ├── race_viewmodel.dart         # Race timer, slider position per car, winner
│   └── result_viewmodel.dart       # Payout calc, wallet update, reset
├── views/
│   ├── login/
│   │   ├── login_screen.dart
│   │   └── widgets/
│   │       └── login_form.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── wallet_badge.dart
│   │       └── volume_setting_panel.dart
│   ├── track_select/
│   │   ├── track_select_screen.dart
│   │   └── widgets/
│   │       └── track_card.dart
│   ├── bet/
│   │   ├── bet_screen.dart
│   │   └── widgets/
│   │       ├── car_selector_list.dart
│   │       ├── car_info_panel.dart
│   │       └── bet_slider.dart
│   ├── race/
│   │   ├── race_screen.dart
│   │   └── widgets/
│   │       ├── race_track_painter.dart   # CustomPainter for track shape
│   │       ├── car_icon_widget.dart      # Animated car icon on track
│   │       └── race_slider_indicator.dart # Fake slider showing race progress
│   └── result/
│       ├── result_screen.dart
│       └── widgets/
│           ├── winner_banner.dart
│           └── payout_summary.dart
└── assets/
    ├── data/
    │   ├── cars.json
    │   └── tracks.json
    ├── audio/
    │   ├── begin.mp3             # Pre-race countdown
    │   ├── racing.mp3            # Loop during race
    │   ├── winner.mp3            # Race finished fanfare
    │   ├── track_figure8.mp3     # Custom audio: figure-8 track
    │   ├── track_circle.mp3      # Custom audio: circle track
    │   └── track_square.mp3      # Custom audio: square track
    └── images/
        ├── car_1.png
        ├── car_2.png
        ├── car_3.png
        └── tracks/
            ├── figure8_preview.png
            ├── circle_preview.png
            └── square_preview.png
```

---

## Data Models

### `cars.json`
```json
[
  { "id": 1, "name": "Thunder", "speed": 85, "asset": "assets/images/car_1.png", "color": "#C33332" },
  { "id": 2, "name": "Storm",   "speed": 78, "asset": "assets/images/car_2.png", "color": "#000080" },
  { "id": 3, "name": "Blaze",   "speed": 90, "asset": "assets/images/car_3.png", "color": "#87CEEB" }
]
```

### `tracks.json`
```json
[
  { "id": 1, "name": "Figure 8", "type": "figure8", "audioKey": "track_figure8" },
  { "id": 2, "name": "Circle",   "type": "circle",  "audioKey": "track_circle"  },
  { "id": 3, "name": "Square",   "type": "square",  "audioKey": "track_square"  }
]
```

---

## ViewModels Detail

### `AuthViewModel`
- State: `username`, `isLoggedIn`
- Actions: `login(username, password)` — hardcoded validation; `logout()`
- Used by: LoginScreen, HomeScreen (logout button)

### `HomeViewModel`
- State: `walletBalance` (double), `volume` (0.0–1.0)
- Actions: `setVolume(double)`, `logout()`
- Persists wallet across screens via `ChangeNotifier` at app root

### `TrackViewModel`
- State: `tracks` (List\<TrackModel\>), `selectedTrack`
- Actions: `loadTracks()`, `selectTrack(TrackModel)`

### `BetViewModel`
- State: `cars` (List\<CarModel\>), `selectedCar`, `betAmount` (double, 0–walletBalance), `frequencyCount` (int — teacher's random number input for race frequency)
- Actions: `selectCar(CarModel)`, `setBet(double)`, `setFrequency(int)`, `canPlay()` → bool
- `canPlay()` returns true only if car selected and betAmount > 0 and betAmount ≤ walletBalance

### `RaceViewModel`
- State: `raceState` (RaceState enum), `progress` (Map\<carId, double\> 0.0–1.0), `winner` (CarModel?)
- Actions: `startRace(track, cars, frequencyCount)`, `_tick()` — called by Timer.periodic; each tick adds `(random * baseSpeed * frequencyMultiplier)` to each car's progress; first to reach 1.0 wins
- Audio triggers: idle→racing = play `begin.mp3` then `track_X.mp3`; on winner = play `winner.mp3`
- `progress` values drive both `AnimatedPositioned` for car icons and the custom `race_slider_indicator`

### `ResultViewModel`
- State: `winner`, `betAmount`, `selectedCar`, `payout` (double), `newBalance` (double)
- Actions: `calculate(winner, bet, selectedCar, currentBalance)` — if selectedCar == winner: payout = betAmount × 2; else payout = -betAmount; `resetGame()` → clears state, navigates to Home

---

## Navigation Flow

```
LoginScreen
    └── HomeScreen (walletBalance displayed in header)
            ├── [Settings icon] → Volume Panel (bottom sheet)
            ├── [Logout icon] → back to LoginScreen
            ├── [Choose Track] → TrackSelectScreen
            │       └── [Select track] → BetScreen
            │               └── [Play button] → RaceScreen
            │                       └── [auto-navigate on finish] → ResultScreen
            │                               ├── [Play Again] → BetScreen
            │                               └── [Back to Home] → HomeScreen
```

---

## Race Logic (Slider Mechanic)

Per teacher's requirement, the race screen uses a **custom slider UI** (not Flutter's Slider widget):

```
For each car:
  Track = Container (full width, styled per track shape color)
  Racer = Icon/Image widget (car asset)
  Position = AnimatedPositioned driven by RaceViewModel.progress[carId]

Slider visual:
  - Background track bar (Container)
  - Thumb = car icon image
  - Position = Alignment.lerp(start, end, progress)

Race frequency:
  - User sets an integer N on BetScreen (teacher's "random number input")
  - Timer.periodic interval = (1000 / N).ms  →  higher N = faster ticks = more frequent updates
  - Each tick: car progress += Random().nextDouble() * (car.speed / 100) * (1 / N)
```

---

## Audio State Machine

| App State | Audio File | Behavior |
|---|---|---|
| Pre-race (BetScreen open) | none | Silence |
| Race begins (Start pressed) | `begin.mp3` | Play once |
| During race | `racing.mp3` + `track_X.mp3` | Loop until winner |
| Winner determined | `winner.mp3` | Play once, stop others |
| Result screen idle | none | Silence |

Track-specific audio layers over the common racing loop. `AudioManager` handles simultaneous channels.

---

## State Management

Use **`provider`** package with `MultiProvider` at app root:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ChangeNotifierProvider(create: (_) => TrackViewModel()),
    ChangeNotifierProvider(create: (_) => BetViewModel()),
    ChangeNotifierProvider(create: (_) => RaceViewModel()),
    ChangeNotifierProvider(create: (_) => ResultViewModel()),
  ],
  child: const App(),
)
```

---

## Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2          # MVVM state management
  audioplayers: ^6.0.0      # Multi-channel audio
  go_router: ^13.0.0        # Declarative navigation

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

---

## Folder Conventions

- One screen = one folder under `views/`
- Each screen folder contains `<name>_screen.dart` + `widgets/` subfolder
- ViewModels never import Flutter widgets — only Dart + models
- Models are plain Dart classes (no Flutter dependency)
- All hardcoded strings go in `app_strings.dart`; no string literals in widgets
