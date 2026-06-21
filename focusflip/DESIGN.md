---
name: FocusFlip
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1b1b1b'
  surface-container: '#1f1f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#c2c6d6'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#303030'
  outline: '#8c909f'
  outline-variant: '#424754'
  surface-tint: '#adc6ff'
  primary: '#adc6ff'
  on-primary: '#002e6a'
  primary-container: '#4d8eff'
  on-primary-container: '#00285d'
  inverse-primary: '#005ac2'
  secondary: '#c6c6c7'
  on-secondary: '#2f3131'
  secondary-container: '#454747'
  on-secondary-container: '#b4b5b5'
  tertiary: '#c8c6c5'
  on-tertiary: '#313030'
  tertiary-container: '#929090'
  on-tertiary-container: '#2a2a2a'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#004395'
  secondary-fixed: '#e2e2e2'
  secondary-fixed-dim: '#c6c6c7'
  on-secondary-fixed: '#1a1c1c'
  on-secondary-fixed-variant: '#454747'
  tertiary-fixed: '#e5e2e1'
  tertiary-fixed-dim: '#c8c6c5'
  on-tertiary-fixed: '#1c1b1b'
  on-tertiary-fixed-variant: '#474746'
  background: '#131313'
  on-background: '#e2e2e2'
  surface-variant: '#353535'
typography:
  display:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.04em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
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
    lineHeight: '1.6'
  label-md:
    fontFamily: Geist
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.4'
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: '1.2'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  container-margin: 24px
  gutter: 16px
---

## Brand & Style
The brand personality is disciplined, serene, and sophisticated. Designed for high-performance students and professionals, the design system prioritizes "deep work" by removing all visual friction. 

The aesthetic is a hybrid of **Minimalism** and **Glassmorphism**, drawing inspiration from the precise utility of Linear and the editorial clarity of Apple. The interface should feel like a premium physical object—a dark glass monolith where information floats with purpose. Every interaction must feel intentional, utilizing generous whitespace to prevent cognitive overload during intense study sessions.

## Colors
The palette is rooted in **AMOLED Black (#000000)** to minimize light emission and maximize focus. 
- **Primary:** Vibrant Blue (#3B82F6) is used sparingly for active states, primary actions, and "Focus Mode" progress indicators.
- **Surface:** Glass layers use white with extreme transparency (3-5%) combined with high-density backdrop blurs.
- **Typography:** Pure White (#FFFFFF) for high-contrast headlines; muted greys (rgba(255,255,255,0.6)) for secondary metadata.
- **Accents:** Success and error states should follow the same high-vibrancy, low-occupancy rule.

## Typography
The system uses **Inter** for its systematic, neutral reliability across all UI elements. For a technical, "Nothing-inspired" edge, **Geist** is used for labels, timers, and data points to provide a clean, monospaced feel without sacrificing legibility. 

Tight letter-spacing is applied to larger headlines to create a compact, modern editorial look. Body text remains open and legible. All numerical data (timers, session counts) should utilize tabular font features to prevent "shimmering" during countdowns.

## Layout & Spacing
This design system utilizes a **Fixed Grid** approach for desktop (max-width: 1200px) and a fluid, high-margin layout for mobile. 
- **Rhythm:** A strict 8px base unit drives all spacing. 
- **Margins:** Mobile views require a generous 24px side margin to create a sense of "breathing room" around content cards.
- **Negative Space:** Use `xl` spacing (80px) between major sections to reinforce the minimalist philosophy. Components should never feel crowded; when in doubt, increase the padding.

## Elevation & Depth
Depth is created through **Tonal Layering** and **Backdrop Blurs** rather than traditional drop shadows.
- **Level 0 (Base):** Pure #000000 background.
- **Level 1 (Cards):** A semi-transparent white fill (rgba(255, 255, 255, 0.04)) with a 20px backdrop blur and a 1px solid border (rgba(255, 255, 255, 0.1)).
- **Level 2 (Modals/Popovers):** Higher opacity fill (0.08) with a subtle ambient glow shadow (0px 20px 40px rgba(0, 0, 0, 0.5)) to lift it off the glass surface.
- **Interactions:** Hover states should slightly increase the border opacity rather than changing the background color significantly.

## Shapes
The shape language is "Squircle-adjacent"—rounded and organic but disciplined. 
- **Standard UI elements** (inputs, small cards) use a 0.5rem (8px) radius.
- **Containers and Large Buttons** use "rounded-xl" (1.5rem / 24px) to feel friendly and tactile.
- **Progress Bars** and **Chips** should always use a full pill-shape (9999px) to contrast against the structured grid of the cards.

## Components
- **Buttons:** Primary buttons are large (56px height) with a solid White fill and Black text. Secondary buttons use the glass style (blur + thin border).
- **Chips:** Used for "Tags" or "Session Types." High-transparency background with a 1px border. The active chip takes the Primary Blue accent.
- **Cards:** The core of the UI. Must have a `backdrop-filter: blur(20px)` and a subtle inner-glow (top border slightly brighter than the bottom).
- **Inputs:** Minimalist bottom-border only, or a fully enclosed glass container. Focus state is indicated by the Blue accent border.
- **Bottom Navigation:** A floating glass dock. Icons should be thin-stroke (1.5pt) and use the Blue accent only for the active state indicator (a small dot below the icon).
- **Timer Display:** The focal point. Use `display` typography, centered, with high-contrast White text.