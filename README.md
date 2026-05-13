# Niviento-Shaderpack

A comprehensive collection of post-processing shader effects for ReShade, featuring vintage analog video emulation, display simulation, and lighting effects.

## Overview

This shader pack contains ReShade effects created by me (NIVIENTO). All shaders are licensed under the MIT license and are designed to provide authentic retro and analog-inspired visual effects for games and applications.

## Included Effects

### CRT / Display Simulation
**Location:** `CRT/NVTO_CRT.fx`

Authentic cathode ray tube (CRT) monitor emulation effect that simulates classic television and arcade display characteristics:
- **Scanlines:** Horizontal scanning line simulation with adjustable intensity and sharpness
- **Phosphor Mask:** RGB phosphor dot matrix pattern for authentic CRT look
- **RGB Offset:** Chromatic aberration effect mimicking color beam misalignment
- **Glow Effect:** Soft bloom to simulate CRT phosphor persistence
- **Virtual Resolution:** Downsamples to a virtual resolution for pixelated retro appearance
- **Edge Fade:** Smooth edges with vignette-style fade

### Bloom / Glow Effect
**Location:** `LIGHT/NVTO_Bloom1.fx`

Advanced bloom and glow effect for HDR-like lighting:
- **Adaptive Threshold:** Selectively brightens only the brightest areas
- **Soft Knee:** Smooth transition between bloomed and non-bloomed areas
- **Directional Bloom:** Configurable horizontal and vertical spread
- **Intensity Control:** Adjust overall bloom strength
- **Debug View:** Preview bloom layers and intermediate processing stages

### VHS / Analog Tape Effects
**Location:** `VHS/` folder

#### NVTO_VHS.fx
Complete VHS tape degradation simulation with realistic analog video artifacts:
- **Composite Processing:** NTSC color signal processing for authentic tape feel
- **Chroma Delay:** Color shift effect characteristic of VHS playback
- **Chroma Bleed:** Color bleeding into luminance channels
- **Dot Crawl:** Animated moving dots along color transitions (typical VHS artifact)
- **Tape Damage:** Simulated physical tape wear and degradation
- **Head Switching:** Horizontal glitches from tape head transitions
- **Tape Wobble:** Temporal jitter simulating mechanical imperfections
- **Color Noise:** Random color noise in chroma channels

#### NVTO_ChromaSmear.fx
Specialized chroma aberration and color separation effect:
- **Chroma Smear:** Color channel spreading and blurring
- **Chroma Delay:** Independent color channel timing offset
- **Luma Softness:** Luminance channel blur for authentic composite look
- **I/Q Separation:** Advanced color space separation
- **Chroma Saturation:** Independent color saturation control

### Utility Effects
**Location:** `z_utility/`

#### NVTO_ScreenZoom.fx
Simple and efficient screen zoom and pan effect:
- **Screen Zoom:** Zoom in or out with black letterboxing for out-of-bounds areas
- Perfect for retro games or as a base for cinematic zoom effects

## Installation

1. Install [ReShade](https://reshade.me/) for your game/application
2. Copy the shader `.fx` files to your ReShade `Shaders` directory
3. Enable the shaders through ReShade's in-game menu
4. Adjust settings to your preference

## Author

Created by **NIVIENTO** (2026)
- Steam: https://steamcommunity.com/id/Niviento/

## License

All shaders in this pack are licensed under the **MIT License**. You are free to use, modify, and distribute these shaders with proper attribution.

## Technical Details

- **Framework:** ReShade FX (DirectX 9/10/11 compatible)
- **Color Space Support:** RGB, NTSC composite video simulation

---

For more information and support, visit the author's Steam profile or check ReShade documentation.