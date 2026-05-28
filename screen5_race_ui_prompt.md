# UI/UX Prompt – Screen 5: Race Screen
## Mini Racing Game · Flutter Mobile App

---

### Design Brief

Generate a race screen in **LANDSCAPE orientation (812×375px)**. The wide format gives the race track room on the left and the 3 custom slider progress bars on the right. This is the most visually dynamic screen — cars animate left-to-right as the race progresses, and the car icon IS the slider thumb.

---

### Color Palette (strict)
- **Primary Red** `#C33332` — race progress fill (Car 1), start button, winner highlight
- **Sky Blue** `#87CEEB` — track surface, background, progress bar track base (Car 3)
- **Navy** `#000080` — app bar, track outlines, labels, Car 2 progress fill
- **Yellow** `#FFFF00` — winner crown, finish line stripe, countdown text, wallet badge

---

### Layout Structure

**1. App Bar (full width, 52px tall)**
- Background: navy `#000080`
- Left: back arrow (white, disabled/greyed during race)
- Center: **"RACE!"** bold white 22px
- Right: wallet badge 💰 $100.00 (yellow pill)
- Below app bar: full-width status strip (20px tall):
  - Pre-race: "READY…" — blinking yellow text on navy
  - During race: "● RACING…" — red animated pulse dot + white text
  - Finished: "🏆 WINNER FOUND!" — yellow text on navy

**2. Two-Column Race Layout (below status strip, remaining ~300px)**
- Split: Left 48% (track canvas) | Right 52% (progress sliders + control)
- 8px gap, 8px horizontal padding

---

**LEFT COLUMN — Track Canvas (~380px wide × 300px tall)**
- Background: sky blue `#87CEEB` at 30% tint
- The selected track shape rendered as a CustomPainter canvas, centered in the column:

  Track rendering (all tracks share the same style):
  - Road band: 20px thick sky blue `#87CEEB` path with navy `#000080` outer/inner edge lines (1.5px)
  - White dashed center-line along the path
  - Yellow `#FFFF00` checkered stripe at the finish line position

  **Figure 8 track:** infinity-loop / figure-8 shape, ~280px wide × 200px tall
  **Circle track:** large oval, ~260px wide × 200px tall
  **Square track:** rounded-corner rectangle ~260×190px, red brake-zone corner dots

  **3 Car icons on the track (moving along the path):**
  - Each car: flat top-down icon, 18×28px
  - Car 1 "Thunder": red body
  - Car 2 "Storm": navy body
  - Car 3 "Blaze": sky blue body (with darker outline for visibility)
  - Position is driven by race progress (0%–100% along path)

  **Icon states per race phase:**
  - Pre-race: static car + small grey clock ⏱ overlay badge
  - Racing: car icon + animated exhaust puff trails behind (3 tiny fading dots)
  - Winner: gold tinted car + 👑 crown floating above + sparkle ✨ burst
  - Loser (after winner): greyed-out car + small ✗ badge

---

**RIGHT COLUMN — Progress Sliders + Button (~424px wide × 300px tall)**
- Background: white, left border navy 1px
- 12px padding

  **Label row at top:**
  - "RACE PROGRESS" navy bold 13px left-aligned

  **Three custom slider rows (each ~68px tall, stacked vertically, 8px gap):**

  Each row layout (left to right):
  - Car mini icon (16×24px) + car name (navy bold 12px) — fixed left 80px
  - Custom slider bar (fills remaining width):
    - Outer track: full-width rounded rect, 12px tall, grey background
    - Filled portion: left-to-right fill showing % complete
      - Car 1 (Thunder): fill color red `#C33332`
      - Car 2 (Storm): fill color navy `#000080`
      - Car 3 (Blaze): fill color sky blue `#87CEEB` (darker tint)
    - **Thumb = the car icon itself:**
      - Same top-down car icon (22×16px), positioned at the fill edge
      - White circle background (28px) with navy border ring
      - The thumb slides horizontally as progress increases
      - At finish: thumb turns gold, gets crown badge above it
    - Right end: 🏁 small checkered flag icon (finish line marker, 16px)
  - Progress value: navy 11px right of the flag (e.g. "87%")

  **Status badges (shown after race ends, below each row):**
  - Winner row: yellow `#FFFF00` pill — "🏆 WINNER"
  - Loser rows: grey pill — "DNF" or "2nd / 3rd"

  **Divider** — navy 1px, full width, 8px margin

  **Control Button (bottom of right column, 44px tall):**
  - Pre-race: **"▶ START RACE"** — red `#C33332` bg, yellow border 2px, bold white text, full width pill
  - During race: **"RACING…"** — grey disabled bg, animated spinner, text grey
  - Post-race: **"VIEW RESULTS →"** — red bg, bold white, full width; auto-navigates after 2s

---

### Audio State Indicators (small speaker icon in status strip)
| State | Icon | Audio |
|---|---|---|
| Pre-race | 🔇 | Silence |
| Countdown | 🔔 | `begin.mp3` once |
| Racing | 🔊 | `racing.mp3` loop + `track_X.mp3` layer |
| Winner | 🏆 | `winner.mp3` plays, others stop |

---

### UI Notes
- Landscape orientation is ideal for this screen — the wide format lets the track be spacious on the left while sliders stay clearly readable on the right
- The custom slider thumb being the car icon is the key teacher requirement — make it visually unmistakable
- No Flutter default Slider widget anywhere on this screen
- During racing, all 3 car icons on the track AND the 3 slider thumbs animate simultaneously
- The right column slider bars update at the frequency rate N chosen in Screen 4 — higher N = more frequent, smoother animation
- Car icons on the track rotate to face the direction of travel around the track shape
