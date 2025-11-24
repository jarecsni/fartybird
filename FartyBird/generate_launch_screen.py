#!/usr/bin/env python3
"""
Generate a simple launch screen image for Farty Bird.
"""

from PIL import Image, ImageDraw, ImageFont

def create_launch_screen():
    """Create a simple launch screen with the game title."""
    # Use a standard iPhone size - larger for better quality
    width, height = 1170, 2532  # iPhone 14 Pro size (3x)
    
    # Create image with yellow/orange background
    img = Image.new('RGBA', (width, height), (255, 200, 50, 255))
    draw = ImageDraw.Draw(img)
    
    # Draw title with much larger font
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 140)
    except:
        font = ImageFont.load_default()
    
    title = "FARTY BIRD"
    bbox = draw.textbbox((0, 0), title, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (width - text_width) // 2
    y = (height - text_height) // 2
    
    # Draw text with outline for better visibility
    outline_color = (200, 150, 50, 255)
    for dx, dy in [(-3,-3), (-3,3), (3,-3), (3,3), (-3,0), (3,0), (0,-3), (0,3)]:
        draw.text((x+dx, y+dy), title, font=font, fill=outline_color)
    draw.text((x, y), title, font=font, fill=(255, 255, 255, 255))
    
    # Save
    import os
    output_path = "FartyBird/FartyBird/Assets.xcassets/LaunchImage.imageset/launch_image.png"
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, 'PNG')
    print(f"Created: {output_path}")
    print(f"Image size: {width}x{height}")
    print(f"Text size: {text_width}x{text_height}")
    print(f"Text position: ({x}, {y})")

if __name__ == "__main__":
    create_launch_screen()
    print("\n✅ Launch screen created successfully!")
