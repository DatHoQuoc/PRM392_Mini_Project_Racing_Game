# UI/UX Prompt – Screen 2: Home / Main Hub Screen
## Mini Racing Game · Flutter Mobile App

---

### Design Brief

Generate a mobile home screen in **LANDSCAPE orientation (812×375px)**. Serves as the main hub after login. Uses a top app bar + a two-column card layout below. Height is limited to 375px so all elements must be compact.

---

### Color Palette (strict)
- **Primary Red** `#C33332` — Play Now button, active elements
- **Sky Blue** `#87CEEB` — background, card surfaces
- **Navy** `#000080` — app bar, text, icons
- **Yellow** `#FFFF00` — wallet badge, highlights

---

### Layout Structure

**1. App Bar (top, full width, 52px tall)**
- Background: navy `#000080`
- Left: **"TURBO RACE"** bold white italic (compact logo)
- Center: Wallet Badge — yellow `#FFFF00` pill, navy text — 💰 **$100.00**
- Right: two icon buttons in white — 🔊 Volume/Settings gear icon | 🚪 Logout icon

**2. Hero Banner Strip (below app bar, full width, ~90px tall)**
- Sky blue `#87CEEB` background with a subtle speed-lines pattern
- Left side: racing illustration — 3 cars at a starting grid with a checkered flag motif (~200px wide section)
- Center-right: large text **"WELCOME BACK, [USERNAME]!"** bold white, navy drop shadow, 18px
- Right edge: small trophy icon 🏆 in yellow

**3. Main Content Area (below banner, full width, remaining ~230px)**
- Two-column layout side by side with 16px gap and 16px horizontal padding:

  **LEFT COLUMN (50%) — Navigation Cards (two stacked cards)**

  Card A — "CHOOSE TRACK"
  - White background, navy border 1px, rounded 14px, ~95px tall
  - Left: 🛣️ road/track icon (navy, 32px)
  - Right: title "CHOOSE TRACK" bold navy 14px + subtitle "Pick your course" grey 11px + chevron →

  Card B — "PLAY NOW"
  - Red `#C33332` background, yellow border 2px, rounded 14px, ~95px tall
  - Left: 🏁 flag/play icon (yellow, 32px)
  - Right: title "PLAY NOW" bold white 16px + subtitle "Jump in!" white/70% 11px + chevron → yellow

  **RIGHT COLUMN (50%) — Quick Stats + Hint**

  Three mini stat tiles in a row (each ~30% width of this column):
  - 🏆 Best Win / $0
  - 🎯 Races / 0
  - 💸 Total Bet / $0
  - Each: white bg, navy text, rounded 10px, navy border 1px, 60px tall, text centered

  Below stats (remaining space): a small hint box
  - Sky blue `#87CEEB` tint background, rounded 10px
  - Text: *"💡 Choose a track first, then place your bet!"* — navy 11px italic

**4. Volume Settings Bottom Sheet (when settings tapped)**
- Slides up from bottom, height ~160px, white bg, handle at top
- Title: "SETTINGS" navy bold 14px
- Row: 🔊 "Race Volume" label + horizontal slider (red thumb, sky blue track)
- Row: "Sound Effects" label + on/off toggle switch (red when on)
- Button: "SAVE" pill, red bg, white text, right-aligned

---

### UI Notes
- App bar is compact at 52px — critical since total height is 375px
- Cards use horizontal layout (icon left, text right) NOT vertical stacking — landscape space is wide
- All three stat tiles fit in a single row in the right column
- No scrolling — everything must fit in 375px height total
