# UI/UX Prompt – Screen 6: Result Screen
## Mini Racing Game · Flutter Mobile App

---

### Design Brief

Generate a race result screen in **LANDSCAPE orientation (812×375px)**. Uses a two-column layout: left column = winner celebration banner, right column = bet summary table + action buttons. Everything is compact to fit within 375px height.

---

### Color Palette (strict)
- **Primary Red** `#C33332` — lose banner, Play Again button
- **Sky Blue** `#87CEEB` — background, table row alternates
- **Navy** `#000080` — app bar, table header, text
- **Yellow** `#FFFF00` — winner banner, crown icon, money delta, wallet badge

---

### Layout Structure

**1. App Bar (full width, 52px tall)**
- Background: navy `#000080`
- No back arrow (terminal screen — only forward actions)
- Center: **"RACE RESULTS"** bold white 20px
- Right: updated wallet badge 💰 **$130.00** (yellow pill, navy text — post-race balance)

**2. Two-Column Body (below app bar, ~323px remaining)**
- Split: Left 42% | Right 58%
- 8px gap, 12px horizontal padding

---

**LEFT COLUMN — Winner Celebration (~325px wide)**

  **WIN scenario:**
  - Background: gradient yellow `#FFFF00` → gold `#FFD700`, rounded right edge 16px
  - Top-center: 👑 crown icon 48px, gold
  - Large text: **"YOU WON!"** — navy bold 28px centered
  - Sub-text: **"THUNDER WINS!"** — red `#C33332` bold 16px centered
  - Car illustration: winning car (flat top-down, ~64×96px), centered, with ✨ sparkle burst overlay
  - Money delta: large **"+$30"** — navy bold 24px with green ↑ arrow, centered
  - Confetti dots (small colored dots: red, yellow, navy) scattered around the column

  **LOSE scenario:**
  - Background: gradient navy `#000080` → dark grey, rounded right edge 16px
  - Top-center: 🚩 broken flag or ❌ icon, 48px, white/grey
  - Large text: **"BETTER LUCK!"** — white bold 24px centered
  - Sub-text: **"STORM WINS THE RACE"** — sky blue `#87CEEB` 14px centered
  - Greyed-out car icon of player's car with ✗ badge overlay, ~64×96px
  - Money delta: large **"-$30"** — yellow `#FFFF00` bold 24px with red ↓ arrow, centered

---

**RIGHT COLUMN — Summary & Actions (~467px wide)**
- Background: white, left border navy 1px
- 12px padding, content stacked top to bottom

  **Bet Summary Table (~140px tall):**
  - Title: "BET SUMMARY" navy bold 12px, left-aligned
  - Table (full width of column, compact rows ~28px each):

    | Car | Bet | Result |
    |---|---|---|
    | 🔴 Thunder | $30 | ✅ WIN +$30 |
    | 🔵 Storm | — | — |
    | 🩵 Blaze | — | — |

  - Header row: navy bg, white text, bold, 11px
  - Alternating rows: white / sky blue `#87CEEB` at 20% tint
  - WIN cell: bold green text + ✅ icon
  - LOSE cell: red `#C33332` text + ❌ icon
  - Dash cells: grey centered

  **Wallet Summary Row (~40px):**
  - Displayed as 3 inline labels separated by dividers:
  - "Prev: $100" grey 11px | "Change: +$30" green bold 12px | 💰 **"New: $130"** navy bold 14px
  - Right side: large yellow `#FFFF00` pill showing final balance **"$130"** in navy bold

  **Divider** — navy 1px, full width, 6px margin

  **Action Buttons (two side-by-side, ~56px tall):**
  - Button 1 — **"🔄 PLAY AGAIN"**:
    - Width ~48% of column, pill 44px height
    - Red `#C33332` bg, yellow border 2px, bold white uppercase text
  - Button 2 — **"🚪 EXIT TO HOME"**:
    - Width ~48% of column, pill 44px height
    - White bg, navy border 2px, navy bold uppercase text
  - 8px gap between the two buttons, both bottom-aligned in the column

---

### UI Notes
- Landscape means the celebration and summary live side-by-side — the result is immediately visible without scrolling
- The wallet badge in the app bar shows the POST-race balance — this is the first number the player notices
- Money delta (+$30 / –$30) in the left column is the most emotionally important piece of info — make it large and bold
- The two action buttons are side-by-side (not stacked) because landscape width allows it and keeps them thumb-reachable
- Win and Lose scenarios use opposite color energy: gold/yellow for win, dark navy/grey for loss — both use the same layout structure
- No vertical scrolling — all content fits in 375px total height
