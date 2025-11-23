# Asset Generation Guide for Farty Bird

This guide explains how to generate pixel art sprites for Farty Bird using PixelLab AI.

## Overview

We'll use **PixelLab** to generate consistent, game-ready pixel art sprites. PixelLab offers multiple ways to work, but for this project we recommend starting with the **Simple Web Creator** or **Characters tool** for speed.

## Recommended Approach

### Option 1: Characters Tool (Fastest for Animated Sprites)
Best for creating the main chicken character with animations.

1. **Access**: Visit https://www.pixellab.ai/create-character
2. **Works on**: Desktop and mobile browsers
3. **Perfect for**: Creating directional sprites with built-in animations

**Steps**:
1. Navigate to the Characters page
2. Enter your prompt: "comic chicken character, pixel art, side view"
3. Select 4-direction or 8-direction views (4 is fine for Farty Bird)
4. Add animations:
   - Idle animation (chicken floating)
   - "Fart" animation (custom - describe the farting motion)
5. Export as sprite sheet
6. Download and save to your project

### Option 2: Simple Web Creator (For Individual Assets)
Best for obstacles, backgrounds, and UI elements.

1. **Access**: Visit https://www.pixellab.ai/create
2. **Works on**: Desktop and mobile browsers
3. **Models**: 
   - Use "BitForge" for small to medium sprites (16x16 to 64x64)
   - Use "PixFlux" for larger images (backgrounds)

**Steps**:
1. Navigate to the Create page
2. Enter your prompt (see prompts below)
3. Generate and iterate until satisfied
4. Download and save to your project

### Option 3: Aseprite Extension (For Advanced Users)
If you already use Aseprite and want more control.

1. **Download**: Get the extension from your PixelLab account page
2. **Install**: Follow the installation guide at https://www.pixellab.ai/docs/installation
3. **Requirements**: Aseprite v1.3+ (paid version, trial doesn't support extensions)

**Workflow**:
1. Open Aseprite
2. Access PixelLab: `Edit > PixelLab > Open plugin` or `Ctrl+Space+P`
3. Use "Create S-M image" tool
4. Start with a rough sketch (init image) for better results
5. Use inpainting to refine specific areas
6. Iterate until perfect

## Complete Asset List for Farty Bird v1.0

### Character Sprites (Priority 1 - Generate First)

#### 1. Chicken - Idle Animation
- **File name**: `chicken_idle.png` (or sprite sheet)
- **Size**: 32x32 pixels
- **Frames**: 2-4 frames for subtle floating motion
- **Prompt**: 
```
comic chicken character, pixel art, side view facing right, 32x32 pixels, idle floating pose, simple clean design, transparent background, game sprite
```

#### 2. Chicken - Fart Animation
- **File name**: `chicken_fart.png` (or sprite sheet)
- **Size**: 32x32 pixels (character) + effect
- **Frames**: 3-5 frames showing thrust motion
- **Prompt**:
```
comic chicken character, pixel art, side view facing right, 32x32 pixels, farting upward thrust pose, tail feathers ruffled, simple design, transparent background, game sprite
```

#### 3. Chicken - Falling Animation
- **File name**: `chicken_falling.png` (or sprite sheet)
- **Size**: 32x32 pixels
- **Frames**: 2-3 frames showing tumbling
- **Prompt**:
```
comic chicken character, pixel art, side view, 32x32 pixels, falling tumbling pose, wings flapping frantically, simple design, transparent background, game sprite
```

#### 4. Tombstone Sprite
- **File name**: `tombstone.png`
- **Size**: 48x64 pixels
- **Frames**: 1 static image (animation handled by code)
- **Prompt**:
```
pixel art tombstone, grey stone, simple cross on top, blank space for text inscription, 48x64 pixels, side view, grass at base, transparent background, game sprite
```

### Obstacle Sprites (Priority 2)

#### 5. Pipe Top
- **File name**: `pipe_top.png`
- **Size**: 64 pixels wide, 400+ pixels tall (tileable)
- **Prompt**:
```
vertical green pipe obstacle, pixel art, top section with cap, 64 pixels wide, game asset, side view, simple design, transparent background, flappy bird style
```

#### 6. Pipe Bottom
- **File name**: `pipe_bottom.png`
- **Size**: 64 pixels wide, 400+ pixels tall (tileable)
- **Prompt**:
```
vertical green pipe obstacle, pixel art, bottom section with cap, 64 pixels wide, game asset, side view, simple design, transparent background, flappy bird style
```

### Background Elements (Priority 3)

#### 7. Sky Background
- **File name**: `background_sky.png`
- **Size**: 512x512 pixels (tileable horizontally)
- **Prompt**:
```
simple sky background, pixel art, light blue gradient, few white clouds, seamless horizontal tile, 512x512 pixels, calm atmosphere, game background
```

#### 8. Ground Texture
- **File name**: `ground.png`
- **Size**: 512x64 pixels (tileable horizontally)
- **Frames**: 1 static tileable texture
- **Prompt**:
```
pixel art ground texture, grass and dirt, side scrolling game, seamless horizontal tile, 512x64 pixels, simple design, green grass top with brown dirt below
```

### UI Elements (Priority 4)

#### 9. Number Sprites (0-9)
- **File name**: `numbers_spritesheet.png` or individual `num_0.png` through `num_9.png`
- **Size**: 16x24 pixels per digit
- **Prompt**:
```
pixel art numbers 0 through 9, bold white font with black outline, 16x24 pixels each, game UI, clear readable digits, sprite sheet layout
```

#### 10. Play Button
- **File name**: `button_play.png`
- **Size**: 128x64 pixels
- **Prompt**:
```
pixel art play button, rounded rectangle, bright green, white text saying PLAY, 128x64 pixels, game UI button, simple design
```

#### 11. Title Logo
- **File name**: `title_logo.png`
- **Size**: 256x128 pixels
- **Prompt**:
```
pixel art game logo text "FARTY BIRD", bold comic style font, yellow and orange colors, 256x128 pixels, funny playful style, transparent background
```

#### 12. Settings Button Icon
- **File name**: `icon_settings.png`
- **Size**: 32x32 pixels
- **Prompt**:
```
pixel art settings gear icon, 32x32 pixels, simple grey gear, game UI icon, transparent background
```

#### 13. Sound Toggle Icons
- **File name**: `icon_sound_on.png` and `icon_sound_off.png`
- **Size**: 32x32 pixels each
- **Prompt for ON**:
```
pixel art speaker icon with sound waves, 32x32 pixels, simple design, game UI icon, transparent background
```
- **Prompt for OFF**:
```
pixel art speaker icon with X or slash, 32x32 pixels, muted sound icon, simple design, game UI icon, transparent background
```

## Generation Order (Recommended)

1. **Start with the chicken idle animation** - This is your core asset. Get this right first.
2. **Generate fart animation** - Test the main mechanic visually (particle effect will be coded).
3. **Create pipes** - You need obstacles to have a game.
4. **Add tombstone** - Complete the death sequence.
5. **Generate falling animation** - Polish the death sequence.
6. **Create backgrounds** - Sky and ground for visual context.
7. **Make UI elements** - Numbers, buttons, logo last.

Note: The fart cloud effect will be created using SpriteKit's particle system (SKEmitterNode), not a sprite asset.

## Alternative: Use PixelLab Characters Tool

For the chicken animations (idle, fart, falling), you can use the Characters tool in one go:

1. Go to https://www.pixellab.ai/create-character
2. Main prompt: `comic chicken character, pixel art, side view, simple design, game sprite`
3. Select 4-direction view (we only need right-facing)
4. Add custom animations:
   - "idle floating"
   - "farting upward thrust"
   - "falling tumbling"
5. Export as sprite sheet
6. Extract the right-facing animations

This gives you all chicken states in one consistent style.

## Tips for Better Results

1. **Start with sketches**: Even rough sketches as init images improve results dramatically
2. **Use inpainting**: If one part looks wrong, use inpainting to fix just that area
3. **Iterate**: Generate multiple versions and pick the best
4. **Keep it simple**: Simpler prompts often work better for pixel art
5. **Consistent style**: Use similar prompts across all assets to maintain visual consistency
6. **Size matters**: Specify pixel dimensions in your prompts (e.g., "32x32 pixels")

## Asset Organization

Once generated, organize assets like this:
```
Assets/
  Sprites/
    Characters/
      chicken_idle.png
      chicken_fart.png
      chicken_hit.png
    Obstacles/
      pipe_top.png
      pipe_bottom.png
  Backgrounds/
    sky.png
    ground.png
  UI/
    numbers_spritesheet.png
    title_screen.png
```

## Making Assets Swappable

To easily swap themes (Farty Chicken → Farty Spaceman):

1. **Use consistent naming**: Always use generic names like `character_idle.png`
2. **Create asset packs**: Each theme gets its own folder
3. **Asset manifest**: Create a simple config file that points to the current theme

Example structure:
```
Assets/
  Themes/
    chicken/
      character_idle.png
      character_fart.png
    spaceman/
      character_idle.png
      character_fart.png
  current_theme.json  <- Points to active theme
```

## Cost Considerations

- PixelLab requires a subscription for full access
- Free tier may have limited generations
- Check current pricing at https://www.pixellab.ai/pricing

## Alternative Tools (If Needed)

If PixelLab doesn't work out:
- **PixelVibe** (by Rosebud AI) - Similar capabilities
- **Aseprite** (manual) - Traditional pixel art creation
- **Piskel** (free) - Browser-based pixel art editor
- **OpenGameArt.org** - Free game assets (if you want to start with existing art)

## Next Steps

1. Create a PixelLab account
2. Generate the chicken character first (this is your core asset)
3. Test it in a simple prototype to ensure the style works
4. Generate remaining assets once chicken is approved
5. Export all assets in appropriate formats for iOS (PNG with transparency)

## Questions?

If you run into issues or need different assets, we can adjust the prompts or try alternative approaches.
