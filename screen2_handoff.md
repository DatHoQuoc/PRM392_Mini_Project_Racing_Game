# Bàn giao – Screen 2
## Mini Racing Game · Flutter

Tài liệu cho người **thiết kế & code Screen 2**. Screen 1 (Login) và Screen 3 (Track
Selection) đã xong và đã đấu nối sẵn. Bạn chỉ cần thay **placeholder** bằng màn thật.

---

## 1. Vị trí code

| Việc | File |
|------|------|
| ⚠️ File tạm cần thay | `lib/views/_tmp/screen2_placeholder.dart` |
| Khai báo route + `MultiProvider` | `lib/main.dart` |
| Model track được chọn | `lib/data/models/track_option_model.dart` |
| Repository load track | `lib/data/repositories/game_repository.dart` (`loadTrackOptions()`) |
| ViewModel auth (login/logout) | `lib/viewmodels/auth_viewmodel.dart` |
| ViewModel track (chọn track) | `lib/viewmodels/track_viewmodel.dart` |

> 🧭 **Project dùng MVVM + `provider`.** `AuthViewModel` và `TrackViewModel` đã được
> đăng ký sẵn trong `MultiProvider` ở `main.dart`, nên Screen 2 đọc/ghi state qua
> `context.read/watch<...>()` mà không cần tự tạo. Xem **mục 4**.

Khi xong, **xoá** thư mục `lib/views/_tmp/` và tạo màn thật tại `lib/views/screen2/`
(theo đúng cấu trúc các màn khác: `screen2_screen.dart` + `widgets/`).

---

## 2. Luồng điều hướng hiện tại

```
LoginScreen (/)
   │  login đúng (user / 1234)  →  pushReplacementNamed(LoginScreen.nextRoute)
   ▼
Screen 2  (route '/game')          ← phần của bạn
   │  bấm "Select Track"  →  pushNamed(TrackSelectScreen.route)
   ▼
TrackSelectScreen ('/track-select')
   │  bấm "CONFIRM TRACK →"  →  Navigator.pop(TrackOption)
   ▼
quay lại Screen 2  (nhận TrackOption đã chọn)
```

- `LoginScreen.nextRoute` = `'/game'` — Login luôn nhảy tới route này.
- Trong `main.dart`, route `'/game'` đang trỏ tới `Screen2Placeholder`. **Đổi dòng này**
  sang màn thật của bạn:

```dart
// lib/main.dart
routes: {
  '/': (_) => const LoginScreen(),
  LoginScreen.nextRoute: (_) => const Screen2Screen(),   // ← màn của bạn
  TrackSelectScreen.route: (_) => const TrackSelectScreen(),
},
```

---

## 3. Hợp đồng dữ liệu — nhận track đã chọn

Screen 3 trả về một `TrackOption` qua `Navigator.pop`. Bạn mở Screen 3 bằng `await` và
nhận kết quả (nhớ `import '../../data/models/track_option_model.dart';`):

```dart
Future<void> _openTrackSelect() async {
  final result = await Navigator.of(context).pushNamed(
    TrackSelectScreen.route,
  );
  if (result is TrackOption) {
    setState(() => _selectedTrack = result);   // LƯU lại track đã chọn
  }
  // result == null nếu người dùng bấm back mà không confirm
}
```

`TrackOption` là **plain Dart model** ở `lib/data/models/track_option_model.dart`
(load từ `tracks.json` qua `GameRepository.loadTrackOptions()`):

```dart
class TrackOption {
  final int       id;
  final TrackType type;          // figure8 / oval / square / f1 — dùng để vẽ & chạy đua
  final String    name;          // "Figure 8", "Circle", "Square", "Grand Prix"
  final String    difficulty;    // "HARD" / "MEDIUM" / "EASY" / "EXPERT"
  final String    description;
  final int       lengthM;       // 480 / 360 / 320 / 620
}
```

> ℹ️ Model **không chứa `Color`** (đúng quy ước "models là plain Dart"). Muốn màu cho
> badge difficulty, dùng hàm `difficultyColor(track.difficulty)` trong
> `track_select_screen.dart` (tầng UI).
>
> 💡 Mẫu tham khảo đầy đủ (nhận + lưu + hiển thị) đang nằm ngay trong
> `screen2_placeholder.dart` — copy logic đó qua màn thật.

---

## 4. Lấy track đã chọn theo MVVM (khuyến nghị)

Có **2 cách** nhận track đã chọn — chọn 1:

**Cách A — `Navigator.pop` (mục 3 ở trên).** Đơn giản, đang dùng ở placeholder. Track
chỉ sống trong state của Screen 2.

**Cách B — đọc `TrackViewModel` qua provider (đúng MVVM, khuyến nghị).** Track Select
đã lưu lựa chọn vào `TrackViewModel.selectedTrack` (state ở app-root), nên Screen 2 đọc
thẳng mà **không cần** `await`/`pop`:

```dart
import 'package:provider/provider.dart';
import '../../viewmodels/track_viewmodel.dart';

// Mở màn chọn track (không cần lấy kết quả trả về):
ElevatedButton(
  onPressed: () => Navigator.of(context).pushNamed(TrackSelectScreen.route),
  child: const Text('Select Track'),
);

// Hiển thị track đang chọn — tự cập nhật khi VM đổi:
final track = context.watch<TrackViewModel>().selectedTrack;
Text(track == null ? 'Chưa chọn track' : track.name);
```

> 💡 Cách B giúp wallet/track/bet dùng chung state qua provider giữa các màn, không phải
> truyền tay. Đây là hướng `ARCHITECTURE.md` đề ra (`TrackViewModel`, `HomeViewModel`...).

**Đăng xuất** (nút "về Login") nên gọi qua VM:

```dart
context.read<AuthViewModel>().logout();
Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
```

---

## 5. Truyền tiếp track sang màn đua (khi cần)

Khi đấu nối với màn đua, truyền `TrackOption` (hoặc `track.type`) qua `arguments`:

```dart
Navigator.of(context).pushNamed('/game-race', arguments: _selectedTrack);
```

`TrackType` map thẳng sang `TrackGeometry.getTrackPoints(type)` để vẽ đường đua.

---

## 6. Quy ước chung (tái sử dụng, đừng hardcode)

| Thứ | Dùng |
|-----|------|
| State / logic | **ViewModel** (`ChangeNotifier`) + `provider` — đừng nhồi logic vào widget |
| Màu | `AppColors` (`lib/core/constants/app_colors.dart`) — palette game: `primaryRed`, `skyBlue`, `navy`, `yellow` |
| Chuỗi text | `AppStrings` (`lib/core/constants/app_strings.dart`) |
| Hằng số | `AppConstants` |
| Toast / thông báo | `ToastService.success/error/...` (`lib/core/utils/toast_service.dart`) |
| Hình track | `TrackGeometry` + `TrackType` |
| Ví (wallet) | hiện default `100.00`; nên đưa vào `HomeViewModel` để dùng chung |

**Định hướng UI:** app khoá **landscape** (812×375) — thiết kế ngang, đừng stack dọc.

---

## 7. Checklist khi hoàn thành

- [ ] Tạo `lib/views/screen2/screen2_screen.dart` (+ `widgets/` nếu cần)
- [ ] (Khuyến nghị) Tạo `HomeViewModel` cho wallet/volume, đăng ký trong `MultiProvider`
- [ ] Nhận track đã chọn — qua `Navigator.pop` (cách A) **hoặc** `TrackViewModel` (cách B)
- [ ] Đổi route `'/game'` trong `main.dart` sang màn thật
- [ ] Xoá thư mục `lib/views/_tmp/`
- [ ] `flutter analyze` sạch lỗi
