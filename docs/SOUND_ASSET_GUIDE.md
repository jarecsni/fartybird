# Sound Asset Guide for Farty Bird

This guide covers how to find, download, and integrate sound effects for Farty Bird using free resources.

## Quick Start: Using Freesound.org

[Freesound.org](https://freesound.org) is a collaborative database of Creative Commons licensed sounds. It's free to use with attribution.

### Setup

1. **Create an account** at [freesound.org](https://freesound.org)
   - Required to download sounds
   - Free and takes 2 minutes

2. **Understand licensing**
   - Most sounds use Creative Commons licenses
   - Common licenses: CC0 (public domain), CC-BY (attribution required)
   - Always check the license before using

### Finding Sounds

#### Fart Sound

1. Search for: `fart`, `flatulence`, `whoopee cushion`, `gas`
2. Filter by:
   - **License**: CC0 or CC-BY (easiest for commercial use)
   - **Duration**: 0.5-2 seconds (short sounds work best)
   - **Sample Rate**: 44100 Hz or higher
3. Preview sounds in browser
4. Look for sounds that are:
   - Clear and distinct
   - Not too long
   - Funny but not offensive

**Recommended searches:**
- "cartoon fart"
- "whoopee cushion"
- "comic fart"

#### Collision Sound

1. Search for: `crash`, `impact`, `hit`, `thud`, `bonk`
2. Filter by:
   - **Duration**: 0.1-0.5 seconds (very short)
   - **License**: CC0 or CC-BY
3. Look for sounds that are:
   - Sharp and immediate
   - Not too harsh
   - Clear impact

**Recommended searches:**
- "cartoon crash"
- "game hit"
- "bonk"

#### Score Sound

1. Search for: `coin`, `point`, `success`, `ding`, `chime`
2. Filter by:
   - **Duration**: 0.2-0.5 seconds
   - **License**: CC0 or CC-BY
3. Look for sounds that are:
   - Pleasant and rewarding
   - Clear tone
   - Not too long

**Recommended searches:**
- "game coin"
- "point score"
- "success chime"

### Downloading and Converting

1. **Download** the sound file (usually WAV or MP3)

2. **Convert to WAV** (if needed):
   ```bash
   # Using ffmpeg (install via: brew install ffmpeg)
   ffmpeg -i input.mp3 -ar 44100 -ac 1 output.wav
   ```

3. **Trim/Edit** (optional):
   - Use [Audacity](https://www.audacityteam.org/) (free)
   - Trim silence from start/end
   - Adjust volume if needed
   - Export as WAV (44100 Hz, mono)

4. **Place in project**:
   ```
   FartyBird/FartyBird/Assets/Sounds/
   ├── fart.wav
   ├── collision.wav
   └── score.wav
   ```

### Attribution

If using CC-BY licensed sounds, add attribution to your app:

1. Create a file: `FartyBird/SOUND_CREDITS.md`
2. List each sound with:
   - Sound name
   - Author
   - License
   - Link to original

Example:
```markdown
# Sound Credits

- **Fart Sound**: "Cartoon Fart" by SoundArtist
  - License: CC-BY 4.0
  - Source: https://freesound.org/people/SoundArtist/sounds/12345/

- **Collision Sound**: "Game Hit" by AudioCreator
  - License: CC0 (Public Domain)
  - Source: https://freesound.org/people/AudioCreator/sounds/67890/
```

## Alternative: Browser-Based Sound Generators

### jsfxr.com

[jsfxr](https://sfxr.me/) is a browser-based retro game sound effect generator.

**Pros:**
- No account needed
- Instant generation
- Great for retro/arcade sounds
- Export directly as WAV

**Cons:**
- Limited to 8-bit style sounds
- Less realistic

**How to use:**
1. Visit [sfxr.me](https://sfxr.me/)
2. Click preset buttons (Jump, Pickup, Hit, etc.)
3. Tweak parameters if desired
4. Click "Export .wav"
5. Save to Assets/Sounds/

**Recommended presets:**
- **Fart**: Use "Explosion" preset, lower pitch, add randomness
- **Collision**: Use "Hit/Hurt" preset
- **Score**: Use "Pickup/Coin" preset

## Alternative: AI Sound Generation

### Soundraw.io or Similar

Some AI tools can generate custom sounds, but quality varies and licensing can be complex.

**Not recommended for this project** - stick with Freesound or jsfxr for simplicity.

## Testing Sounds in Xcode

After adding sounds to `Assets/Sounds/`:

1. **Add to Xcode project**:
   - Drag files into Xcode project navigator
   - Ensure "Copy items if needed" is checked
   - Add to FartyBird target

2. **Test in simulator**:
   - Run the app
   - Trigger actions (tap, collision, score)
   - Adjust volume in AudioManager if needed

3. **Verify on device**:
   - Sounds may be louder/quieter on real device
   - Test with device volume at 50%

## Tips for Good Game Sounds

1. **Keep them short** - 0.5-2 seconds max
2. **Avoid clipping** - sounds shouldn't distort at full volume
3. **Match the tone** - funny game = funny sounds
4. **Test repeatedly** - you'll hear these sounds A LOT while playing
5. **Consider variety** - multiple fart sounds can be rotated randomly

## Troubleshooting

**Sound not playing:**
- Check file is in Xcode project (not just filesystem)
- Verify file is added to app target
- Check AudioManager isn't muted
- Verify file format is WAV (not MP3)

**Sound too quiet/loud:**
- Adjust in AudioManager.swift
- Or edit in Audacity (Effect → Amplify)

**Sound has delay:**
- Use WAV format (not MP3)
- Keep files small (<100KB)
- Preload sounds at app launch

## Next Steps

Once you have your sounds:
1. Replace the placeholder WAV files in `Assets/Sounds/`
2. Test in the app
3. Add attribution if required
4. Consider adding sound variations for variety
