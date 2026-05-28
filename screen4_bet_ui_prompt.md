# UI/UX Prompt – Screen 4: Car Selection & Betting Screen
## Mini Racing Game · Flutter Mobile App

---

### Design Brief

Generate a betting + car selection screen in **LANDSCAPE orientation (812×375px)**. The layout is a three-column design: left column = 3 car choices, center column = selected car stats, right column = bet slider, frequency input, and play button. Everything must fit within 375px height without scrolling.

---

### Color Palette (strict)
- **Primary Red** `#C33332` — selected car, Play button, slider thumb
- **Sky Blue** `#87CEEB` — background, slider track fill
- **Navy** `#000080` — app bar, text, borders, labels
- **Yellow** `#FFFF00` — wallet badge, win multiplier badge, slider value

---

### Layout Structure

**1. App Bar (full width, 52px tall)**
- Background: navy `#000080`
- Left: white back arrow ←
- Center: **"PLACE YOUR BET"** bold white 18px
- Right: wallet badge 💰 $100.00 (yellow pill, navy text)

**2. Three-Column Body (below app bar, full remaining height ~323px)**
- 16px horizontal padding, 8px column gap
- Column widths: Left 22% | Center 38% | Right 40%

---

**LEFT COLUMN — Car List (~178px wide)**
- Background: white, right border navy 1px
- Label: "CARS" navy bold 12px, centered, 8px top padding
- Three car cards stacked vertically, each ~88px tall, 8px gap, 8px horizontal padding:

  Each car card:
  - Car illustration: flat top-down car icon, centered, ~48px wide
    - Car 1 "Thunder": red `#C33332` body
    - Car 2 "Storm": navy `#000080` body
    - Car 3 "Blaze": sky blue `#87CEEB` body
  - Car name below: bold 12px centered
  - Selection state:
    - Unselected: white bg, navy border 1px, rounded 10px
    - Selected: red `#C33332` bg, white car + white name, yellow left accent bar 4px, slight shadow

---

**CENTER COLUMN — Car Info Panel (~308px wide)**
- Background: very light sky blue tint `#87CEEB` at 20% opacity
- Vertically centered content, 12px padding:
  - Car image: 56×56px centered, flat top-down illustration
  - Car name: bold navy 18px, centered
  - Three stat rows (compact, 28px each):
    - 🏎️ Speed — progress bar (red `#C33332` fill) + value right
    - ⚙️ Handling — progress bar + value
    - 🔋 Stamina — progress bar + value
    - Bar height: 8px, rounded, grey background
  - Win multiplier pill badge: yellow `#FFFF00` bg, navy text **"WIN × 2.0"**, centered, 12px top margin

---

**RIGHT COLUMN — Betting Controls (~325px wide)**
- Background: white, left border navy 1px
- 12px padding, content stacked vertically with tight spacing

  **Bet Slider section (~110px):**
  - Label row: "BET AMOUNT" navy bold 12px left + current value yellow `#FFFF00` pill right (e.g. **"$30"**)
  - Custom slider (no Flutter default Slider):
    - Track bar: full-width, 10px tall, rounded, grey bg / red `#C33332` filled portion
    - Thumb: circular 26px, red `#C33332` bg, white "$" icon, yellow ring border
    - Min label "$0" below left, Max label "$100" below right — grey 10px
  - Warning text: "⚠️ Cannot exceed balance" grey 10px, 4px top margin

  **Divider line** — navy 1px, 90% width, centered, 8px vertical margin

  **Race Frequency section (~80px):**
  - Label: "RACE FREQUENCY" navy bold 12px + ℹ️ tooltip icon
  - Stepper row (horizontal, centered):
    - [–] button: 32×32px rounded square, navy border, navy "–"
    - Number display: white box 80px wide, navy border, bold navy number **"5"**, 32px tall
    - [+] button: same as minus
  - Range hint: "Range: 1–20" grey 10px, centered

  **Play Button (~48px):**
  - Full-width of this column, pill shape, 44px height
  - Active: red `#C33332` bg, yellow border 2px, bold white **"▶ PLAY"** 16px uppercase
  - Disabled: grey bg, grey text

---

### UI Notes
- Three columns must all be visible simultaneously — no horizontal scrolling
- The center column is the visual focus (car stats); left and right columns are narrower and more functional
- All interactive elements (slider, stepper, button) are in the right column and reachable with the right thumb in landscape
- Total height is 375px; the app bar takes 52px, leaving 323px for the 3 columns — keep all elements compact
- The custom bet slider thumb (dollar sign coin) visually distinguishes it from the race sliders in Screen 5
