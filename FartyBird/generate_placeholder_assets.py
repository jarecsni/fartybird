#!/usr/bin/env python3
"""
Generate placeholder assets for Farty Bird game.
Creates simple colored rectangles as PNG files for testing.
"""

from PIL import Image, ImageDraw, ImageFont
import os

# Asset dimensions (2x for retina)
CHAR_SIZE = (128, 128)
OBSTACLE_SIZE = (128, 512)
BACKGROUND_SIZE = (750, 1334)  # iPhone size
GROUND_SIZE = (750, 200)
TOMBSTONE_SIZE = (128, 160)
UI_NUMBER_SIZE = (64, 96)
UI_BUTTON_SIZE = (256, 128)
UI_LOGO_SIZE = (512, 256)
UI_ICON_SIZE = (96, 96)

def create_colored_rect(size, color, label="", output_path=""):
    """Create a colored rectangle with optional label."""
    img = Image.new('RGBA', size, color)
    draw = ImageDraw.Draw(img)
    
    if label:
        # Draw label text in center
        try:
            # Try to use a system font
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 24)
        except:
            font = ImageFont.load_default()
        
        # Get text bounding box
        bbox = draw.textbbox((0, 0), label, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        # Center the text
        x = (size[0] - text_width) // 2
        y = (size[1] - text_height) // 2
        
        # Draw text with outline for visibility
        outline_color = (0, 0, 0, 255) if sum(color[:3]) > 384 else (255, 255, 255, 255)
        for dx, dy in [(-1,-1), (-1,1), (1,-1), (1,1)]:
            draw.text((x+dx, y+dy), label, font=font, fill=outline_color)
        
        text_color = (255, 255, 255, 255) if sum(color[:3]) < 384 else (0, 0, 0, 255)
        draw.text((x, y), label, font=font, fill=text_color)
    
    if output_path:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        img.save(output_path, 'PNG')
        print(f"Created: {output_path}")
    
    return img

def main():
    base_path = "FartyBird/Assets"
    
    # Character sprites (chicken theme)
    print("\n=== Creating Character Sprites ===")
    create_colored_rect(CHAR_SIZE, (255, 200, 100, 255), "IDLE", 
                       f"{base_path}/Themes/chicken/character_idle@2x.png")
    create_colored_rect(CHAR_SIZE, (255, 150, 50, 255), "FART", 
                       f"{base_path}/Themes/chicken/character_fart@2x.png")
    create_colored_rect(CHAR_SIZE, (200, 100, 50, 255), "FALL", 
                       f"{base_path}/Themes/chicken/character_falling@2x.png")
    
    # Obstacle sprites
    print("\n=== Creating Obstacle Sprites ===")
    create_colored_rect(OBSTACLE_SIZE, (50, 150, 50, 255), "PIPE", 
                       f"{base_path}/Themes/chicken/pipe_top@2x.png")
    create_colored_rect(OBSTACLE_SIZE, (50, 150, 50, 255), "PIPE", 
                       f"{base_path}/Themes/chicken/pipe_bottom@2x.png")
    
    # Background and ground
    print("\n=== Creating Background Sprites ===")
    create_colored_rect(BACKGROUND_SIZE, (135, 206, 235, 255), "SKY", 
                       f"{base_path}/Themes/chicken/background_sky@2x.png")
    create_colored_rect(GROUND_SIZE, (139, 90, 43, 255), "GROUND", 
                       f"{base_path}/Themes/chicken/ground@2x.png")
    
    # Tombstone
    print("\n=== Creating Tombstone Sprite ===")
    create_colored_rect(TOMBSTONE_SIZE, (128, 128, 128, 255), "RIP", 
                       f"{base_path}/Themes/chicken/tombstone@2x.png")
    
    # UI sprites - Numbers (0-9)
    print("\n=== Creating UI Number Sprites ===")
    for i in range(10):
        create_colored_rect(UI_NUMBER_SIZE, (255, 255, 255, 255), str(i), 
                           f"{base_path}/UI/number_{i}@2x.png")
    
    # UI sprites - Buttons and icons
    print("\n=== Creating UI Buttons and Icons ===")
    create_colored_rect(UI_BUTTON_SIZE, (100, 200, 100, 255), "PLAY", 
                       f"{base_path}/UI/button_play@2x.png")
    create_colored_rect(UI_LOGO_SIZE, (255, 200, 50, 255), "FARTY BIRD", 
                       f"{base_path}/UI/title_logo@2x.png")
    create_colored_rect(UI_ICON_SIZE, (150, 150, 150, 255), "⚙", 
                       f"{base_path}/UI/icon_settings@2x.png")
    create_colored_rect(UI_ICON_SIZE, (100, 150, 255, 255), "🔊", 
                       f"{base_path}/UI/icon_sound_on@2x.png")
    create_colored_rect(UI_ICON_SIZE, (150, 150, 150, 255), "🔇", 
                       f"{base_path}/UI/icon_sound_off@2x.png")
    
    print("\n✅ All placeholder assets created successfully!")

if __name__ == "__main__":
    main()
