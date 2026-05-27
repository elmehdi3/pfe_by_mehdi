---
name: TEAMUP
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#ccc3d8'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#958da1'
  outline-variant: '#4a4455'
  surface-tint: '#d2bbff'
  primary: '#d2bbff'
  on-primary: '#3f008e'
  primary-container: '#7c3aed'
  on-primary-container: '#ede0ff'
  inverse-primary: '#732ee4'
  secondary: '#b4c5ff'
  on-secondary: '#002a78'
  secondary-container: '#0053db'
  on-secondary-container: '#cdd7ff'
  tertiary: '#4ae176'
  on-tertiary: '#003915'
  tertiary-container: '#007733'
  on-tertiary-container: '#84ff9c'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#eaddff'
  primary-fixed-dim: '#d2bbff'
  on-primary-fixed: '#25005a'
  on-primary-fixed-variant: '#5a00c6'
  secondary-fixed: '#dbe1ff'
  secondary-fixed-dim: '#b4c5ff'
  on-secondary-fixed: '#00174b'
  on-secondary-fixed-variant: '#003ea8'
  tertiary-fixed: '#6bff8f'
  tertiary-fixed-dim: '#4ae176'
  on-tertiary-fixed: '#002109'
  on-tertiary-fixed-variant: '#005321'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
typography:
  display-lg:
    fontFamily: Sora
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.04em
  display-lg-mobile:
    fontFamily: Sora
    fontSize: 32px
    fontWeight: '800'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Sora
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1'
    letterSpacing: 0.1em
  stats-number:
    fontFamily: Sora
    fontSize: 20px
    fontWeight: '700'
    lineHeight: '1'
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
The design system embodies the high-stakes, adrenaline-fueled world of elite eSports. The personality is **hyper-professional yet immersive**, mirroring the interface of a AAA gaming title. It aims to evoke a sense of digital mastery and competitive "flow."

The aesthetic is a fusion of **Dark Minimalism and Technical Glassmorphism**. We utilize deep, ink-like voids contrasted against vibrant, neon-infused interactive elements. Surfaces are treated with subtle translucency and "inner-glow" strokes to simulate high-end hardware interfaces. Motion and fluidity are paramount; transitions should feel like a seamless data stream, reinforcing the "futuristic" and "high-performance" nature of the platform.

## Colors
The palette is built on a foundation of **Deep Black (#0F172A)** and an even darker "Void" background (#020617) to provide infinite depth. 

- **Primary Accent (Neon Purple):** Used for critical actions, branding moments, and active states. It represents the "energy" of the platform.
- **Secondary Accent (Electric Blue):** Used for data visualization, secondary navigation, and links. It provides a technical, cooling contrast to the purple.
- **Success (Success Green):** Reserved for victory states, "online" indicators, and completed transactions.

All primary interactive elements should utilize a subtle **Neon Glow** (bloom effect) using the `accent_glow` token to simulate light-emitting hardware.

## Typography
We use **Sora** for headlines and display elements. Its geometric construction and wide stance give it a technical, modern edge suitable for a gaming environment. **Inter** is utilized for body text and utility labels to ensure maximum legibility during fast-paced navigation.

- **Headlines:** Should be tight-leaded and occasionally use uppercase for high-impact "Hero" sections.
- **Data/Stats:** Use the `stats-number` role for player K/D ratios, rankings, and scores to ensure they stand out as primary information.
- **Labels:** Small caps with tracking (letter spacing) are used for "over-lines" or technical metadata.

## Layout & Spacing
The layout follows a **12-column fluid grid** for desktop, collapsing to 4 columns for mobile. 

- **Spacing Rhythm:** We adhere to an 8px base unit. 
- **Density:** Elements should have generous "breathing room" (the `lg` and `xl` tokens) between major sections to maintain a premium feel, but high-density "Control Panels" (like player stats or match lobbies) should use the `sm` and `xs` tokens to keep information compact and visible at a glance.
- **Margins:** Large horizontal margins on desktop (64px) help center the focus and create an "Exclusive" feel.

## Elevation & Depth
This design system avoids traditional drop shadows in favor of **Luminous Depth**.

1.  **Backdrop Blur:** All floating panels (cards, modals) must use a `20px` to `40px` backdrop blur.
2.  **Inner Strokes:** Use a 1px top-down gradient border (from white at 10% opacity to white at 0%) to create a "beveled glass" edge.
3.  **Neon Bloom:** Active elements or "Tier 1" cards feature a soft outer glow using the primary accent color. This replaces standard shadows and indicates high interactivity.
4.  **Z-Index Tiers:** 
    - Base: Background Void.
    - Level 1: Semi-transparent glass panels.
    - Level 2: Interactive components (buttons, inputs).
    - Level 3: Modals and tooltips with increased glow intensity.

## Shapes
We use a **Soft (0.25rem)** rounding strategy. This provides a "technical" and "precise" look that is more aggressive than fully rounded systems but more refined than sharp-edged brutalism.

- **Buttons & Small Components:** Use `rounded` (4px).
- **Cards & Sections:** Use `rounded-lg` (8px).
- **Special Badges:** Use `rounded-xl` (12px) or a clipped-corner (octagonal) aesthetic for "Rank" or "Elite" indicators to signify special status.

## Components

### Buttons
- **Primary:** Gradient fill (Neon Purple to Electric Blue), white text, 4px corner radius. On hover, increase the "bloom" glow intensity.
- **Secondary:** Ghost style with a 1px Electric Blue border. Inner glow appears on hover.
- **Vibrant State:** For "LIVE" or "JOIN MATCH" buttons, use a pulsing animation on the outer glow.

### Glassmorphism Cards
Cards are the primary container. Use `surface_hex` with a 1px border. The background must have a blur effect to ensure text remains legible over dynamic gaming backgrounds.

### Gaming Badges & Icons
- **Badges:** Use high-contrast backgrounds (Success Green for "Win Streak").
- **Icons:** Use thin-line (1.5pt) icons with a "duotone" effect—one color being a neutral gray and the other the primary accent.

### Input Fields
Dark backgrounds, 1px border. When focused, the border glows Neon Purple and the label shifts to the `label-caps` style above the field.

### List Items
Match lobbies or player lists should use alternating row opacities (zebra striping) at very low increments (2% difference) to maintain the clean, technical look without cluttering the UI with lines.