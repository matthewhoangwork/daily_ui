# daily_ui

Chữ ký giao diện của `app/` (daily-vocab), đóng gói để app Flutter mới dùng
chung mà không copy-paste: **khối dày lún được** (nút), **thẻ giấy dày**
(AppCard), **nhãn viên thuốc** (Pill), track tiến độ game, ThemeData Nunito.

## Có gì

| File | Mang từ `app/lib` | Ghi chú |
|---|---|---|
| `src/tokens.dart` | `theme/tokens.dart` | SINH BỞI `design/build_tokens.py` — đừng sửa tay |
| `src/app_theme.dart` | `theme/app_theme.dart` | `buildAppTheme()` + `tierColor()` |
| `src/chunky.dart` | `widgets/chunky.dart` | `chunk()`, `ChunkyButton`, `ChunkyTextButton`, `ChunkyTrack` |
| `src/card.dart` | `widgets/ui.dart` (AppCard, Pill) | Chỉ 2 mảnh signature, không mang cả ui.dart |
| `src/haptics.dart` | `core/haptics.dart` | Rung ở `onTapDown` — thiếu nó nút mất nửa cảm giác |

KHÔNG mang: logic nghiệp vụ (`core/` còn lại, `features/`), Super/paywall
(`super_gradient.dart` — app nào bán gói thì tự thêm khi cần).

## Đồng bộ token

Nguồn sự thật vẫn là `design/tokens.json` ở repo daily-vocab:

```bash
python3 design/build_tokens.py          # ghi vào packages/daily_ui/lib/src/tokens.dart
python3 design/build_tokens.py --check  # CI gate
```

## Tách thành repo riêng (khi app thứ hai thật sự cần)

```bash
git subtree split -P packages/daily_ui -b daily-ui-split
# tạo repo mới, push branch đó, rồi ở mỗi app:
```

```yaml
dependencies:
  daily_ui:
    git:
      url: git@github.com:matthewhoangwork/daily_ui.git
      ref: v0.1.0
```

Trong lúc còn một app: `path: ../packages/daily_ui` (đang dùng ở `app/`).

## App mới dùng

```dart
import 'package:daily_ui/daily_ui.dart';

MaterialApp(theme: buildAppTheme(), home: ...);
ChunkyButton(onPressed: ..., label: 'Hoc');
AppCard(child: ...);
```

Font Nunito + asset brand (sloth) KHÔNG theo package — chép `assets/fonts/`
+ khai `pubspec.yaml` theo `app/pubspec.yaml` (4 nấc 400/600/700/800).
Không font thì `fontFamily` rớt về hệ thống, layout không vỡ.
