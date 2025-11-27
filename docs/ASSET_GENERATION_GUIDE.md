# Asset Generation Guide for Farty Bird

This guide explains how to create high-quality game sprites for Farty Bird using **Ludo.ai Sprite Generator**.

## Why Ludo.ai?

- **Built for game developers** - understands sprite requirements
- **Consistent character generation** - maintains style across poses
- **Animation support** - can generate sprite sheets with multiple poses
- **Free tier available** - try before you buy
- **Export-ready** - PNG with transparency, perfect for games

**Access**: https://ludo.ai/features/sprite-generator

## Getting Started

1. Go to https://ludo.ai
2. Sign up for a free account
3. Navigate to **Sprite Generator** from the dashboard
4. You're ready to create!

## Workflow Overview

Ludo.ai works in two steps:
1. **Generate static sprite** - create your base character
2. **Animate** - add poses (idle, flapping, falling, etc.)

## Step 1: Generate Base Character

### Navigate to "New Sprite" Tab

Enter this prompt:
```
2D cartoon chicken character, side view facing right, white feathers, red comb, yellow beak, orange feet, cute round body, simple clean design, mobile game character, flat art style
```

### Settings
- **Style**: Cartoon/2D Game Art
- **Size**: 512x512 (you'll resize later)
- **Background**: Transparent

Click **Generate** and wait for results (usually 10-30 seconds).

### Pick Your Favorite

Ludo will generate 4 variations. Choose the one that best matches your vision.

## Step 2: Create Poses

Once you have your base character, create different poses:

### Idle Pose
1. Click **Animate** or **Create Pose**
2. Select **Idle** from preset animations
3. Or enter custom prompt: "neutral standing pose, slight bob"
4. Generate

### Flapping Pose
1. Click **Create Pose** or **New Animation**
2. Select **Jump** or **Attack** preset (closest to flapping)
3. Or enter custom prompt: "wings spread out flapping upward, thrust pose"
4. Generate

### Falling Pose
1. Click **Create Pose**
2. Enter custom prompt: "tumbling downward, worried expression, falling"
3. Generate

### Death Pose (Optional)
1. Click **Create Pose**
2. Enter custom prompt: "knocked out, X eyes, stars around head"
3. Generate

## Export Your Sprites

1. Once all poses are generated, click **Export**
2. Choose **Sprite Sheet** or **Individual Frames**
3. Format: **PNG with transparency**
4. Download

## Processing Downloaded Sprites

After downloading from Ludo.ai:

1. **Separate frames** (if sprite sheet) - use any image editor
2. **Resize** to 64x64px (@2x for Retina)
   - Use Preview on Mac, or online tool like https://www.iloveimg.com/resize-image
3. **Rename files**:
   - `character_idle@2x.png`
   - `character_fart@2x.png`
   - `character_falling@2x.png`
   - `character_dead@2x.png` (optional)
4. **Save as PNG** with transparency

## Asset Specifications

### Character Sprites
- **Size**: 64x64 pixels (@2x for Retina)
- **Format**: PNG with transparency
- **Naming**: `character_idle@2x.png`, `character_fart@2x.png`, etc.

### File Organization

Place your assets in the theme folder:

```
FartyBird/FartyBird/Assets/Themes/chicken/
├── character_idle@2x.png
├── character_fart@2x.png
├── character_falling@2x.png
└── character_dead@2x.png (optional)
```

## Tips for Better Results

### Prompt Engineering
- Be specific about style: "2D cartoon", "flat art style", "simple clean design"
- Specify orientation: "side view facing right"
- Mention "mobile game character" for appropriate complexity
- Keep it simple - overly complex prompts can confuse the AI

### Consistency
- Generate all poses from the same base character
- Use Ludo's "Create Pose" feature to maintain consistency
- Don't regenerate the base character for each pose

### Iteration
- Generate multiple variations and pick the best
- Use the **Refine** feature if available to tweak details
- Save your favorite base character for future use

## Troubleshooting

**Character looks different in each pose?**
- Make sure you're using "Create Pose" from the same base character
- Don't generate new characters for each pose

**Background not transparent?**
- Check export settings - ensure "Transparent background" is selected
- Use remove.bg if needed: https://remove.bg

**Style doesn't match?**
- Keep your prompts consistent across all poses
- Use the same style keywords ("2D cartoon", "flat art style")

**Character too detailed/complex?**
- Add "simple design" and "clean" to prompt
- Specify "mobile game character" for appropriate complexity

## Alternative: Other Sprite Assets

### Pipes
For pipes and environment, you can either:
1. Use Ludo.ai with prompts like:
   ```
   vertical green metal pipe, game obstacle, simple design, side view
   ```
2. Or use simple colored rectangles (already implemented in code)

### Background
For sky and ground:
1. Use Ludo.ai or Bing Image Creator
2. Or use simple gradients/colors (can be done in code)

## Pricing

Ludo.ai offers:
- **Free tier**: Limited generations per month
- **Paid plans**: Starting around $10-20/month for unlimited generations

Check current pricing at: https://ludo.ai/pricing

## Alternative Tools

If Ludo.ai doesn't work for you:

1. **Pixelcut AI** - https://www.pixelcut.ai/create/sprite-generator
2. **Fiverr artist** - $30-50 for custom sprite set (most reliable)
3. **Bing Image Creator** - Free but less consistent

## Next Steps

1. Create a Ludo.ai account
2. Generate your chicken character base
3. Create 3-4 poses (idle, flap, fall, death)
4. Export and resize
5. Add to your project
6. Test in game!

## Fart Effect

The fart cloud effect is created using SpriteKit's particle system (SKEmitterNode), not a sprite asset. This is already implemented in the code.
