# UI/UX Prompt – Screen 1: Login Screen
## Mini Racing Game · Flutter Mobile App

---

### Design Brief

Generate a mobile login screen in **LANDSCAPE orientation (812×375px)**. The screen should feel exciting and game-like while remaining clean enough for a simple login form. Wide layout splits into left (branding) and right (form).

---

### Color Palette (strict)
- **Primary Red** `#C33332` — main CTA button
- **Sky Blue** `#87CEEB` — background gradient
- **Navy** `#000080` — background gradient bottom, text, borders
- **Yellow** `#FFFF00` — game logo accent, highlight glow on button

---

### Layout Structure (Left | Right split)

**Background**
- Full-screen gradient: sky blue `#87CEEB` top-left → navy `#000080` bottom-right
- Subtle diagonal speed-line pattern at 10% white opacity across the entire screen

---

**LEFT PANEL (50% width — 406×375px) — Branding**
- Vertically centered content:
  - Large game logo: **"TURBO RACE"** — bold wide italic racing font, white text with yellow `#FFFF00` glow/shadow
  - Below logo: tagline in white italic small text — *"Place your bets. Start your engines."*
  - Below tagline: a flat illustration of 3 racing cars side-by-side (silhouette top-down view), colored red, navy, sky blue, ~120px wide
- No border separating left and right — a subtle vertical gradient fade in the center transitions the two halves

---

**RIGHT PANEL (50% width — 406×375px) — Login Form**
- Vertically centered floating card:
  - Rounded rectangle card, white at 92% opacity, padding 20px, rounded corners 16px
  - Card width: ~340px, height: auto (~240px)
  - **"LOGIN"** label — navy bold 16px, centered, with thin yellow underline
  - **Username field**: outlined text input, height 40px, navy border, navy placeholder
  - **Password field**: outlined text input, height 40px, navy border, eye-toggle icon right
  - **Gap: 12px**
  - **Login Button**: full-width pill, height 44px, red `#C33332` background, bold white "START RACING" uppercase, yellow 2px border outline
  - Below button: small grey text — "Demo: user / 1234"

**Footer**
- Bottom-right corner: "v1.0.0" small muted white text

---

### UI Notes
- Landscape means the form and branding sit side-by-side — never stacked vertically
- Keep vertical padding tight (max 16px top/bottom) since height is only 375px
- The login card must not overflow — all form elements must fit within ~240px height
- Overall vibe: arcade game meets mobile — bold, high contrast, no clutter
