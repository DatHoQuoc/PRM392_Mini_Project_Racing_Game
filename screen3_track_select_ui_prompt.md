# UI/UX Prompt – Screen 3: Track Selection Screen
## Mini Racing Game · Flutter Mobile App

---

### Design Brief

Generate a track selection screen in **LANDSCAPE orientation (812×375px)**. Three track options are displayed side-by-side in a horizontal card row — not stacked — because the wide layout gives each card room to breathe. A confirm button sits at the bottom.

---

### Color Palette (strict)
- **Primary Red** `#C33332` — selected track border, confirm button
- **Sky Blue** `#87CEEB` — background, track road surface
- **Navy** `#000080` — app bar, card text, track outlines
- **Yellow** `#FFFF00` — selection checkmark badge, active glow

---

### Layout Structure

**1. App Bar (full width, 52px tall)**
- Background: navy `#000080`
- Left: white back arrow ←
- Center: **"SELECT TRACK"** bold white 18px
- Right: wallet badge 💰 $100.00 (yellow pill, navy text)

**2. Subtitle (below app bar, 24px tall)**
- *"Choose your racing course"* — navy italic 12px, 16px left padding

**3. Three Track Cards — Horizontal Row (main content)**
- Layout: 3 equal-width cards side by side, 12px gap between, 16px horizontal margin
- Each card: ~248px wide × ~240px tall, white background, rounded corners 16px

  **Card anatomy (same structure for all three, content differs):**

  TOP HALF of card (~120px) — Track Shape Diagram:
  - White canvas area with a subtle light-grey grid background
  - The track shape drawn as a thick sky blue `#87CEEB` road band (18px wide) with navy outline (2px)
  - White dashed center-line running along the path
  - Small directional arrows on the path

  BOTTOM HALF of card (~120px) — Track Info:
  - Track name: bold navy 16px, centered
  - Difficulty badge: small pill (🔴 HARD / 🟡 MEDIUM / 🟢 EASY), centered
  - Description: grey 11px, centered, max 2 lines
  - Track length: 🛣️ "Xm" grey 11px centered

  ---

  **Card 1 — Figure 8:**
  - Shape: infinity loop / figure-8 path
  - Name: "FIGURE 8"
  - Difficulty: 🔴 HARD (red pill)
  - Description: "Cross-over loops, high speed"
  - Length: 480m

  **Card 2 — Circle:**
  - Shape: oval/circle track
  - Name: "CIRCLE"
  - Difficulty: 🟡 MEDIUM (yellow-dark pill)
  - Description: "Smooth turns, consistent speed"
  - Length: 360m

  **Card 3 — Square:**
  - Shape: rounded-corner square track, red corner brake markers
  - Name: "SQUARE"
  - Difficulty: 🟢 EASY (green pill)
  - Description: "Sharp corners, test braking"
  - Length: 320m

  **Selection States:**
  - Unselected: white bg, thin navy border 1px
  - Selected: white bg, thick red `#C33332` border 3px, yellow `#FFFF00` checkmark badge top-right corner (24px circle), soft red drop shadow

**4. Confirm Button (bottom strip, full width, 48px tall)**
- Fixed at bottom, white background strip with navy top border 1px
- Centered pill button: 300px wide, 40px tall
- Active: red `#C33332` bg, bold white "CONFIRM TRACK →" uppercase
- Disabled (nothing selected): grey bg, grey text

---

### UI Notes
- All 3 cards must be visible simultaneously in one row — no carousel or scrolling
- Each card is ~248px wide — tight but readable at 812px total width
- Track shape diagrams are the visual anchor of each card — draw them clearly and distinctly
- The screen has no vertical scrolling; all content fits within 375px height
- Card height is ~240px which fits comfortably between the 76px top area and 48px bottom bar
