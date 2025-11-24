#!/usr/bin/env python3
"""Generate clean pipe textures without hairline borders."""

from PIL import Image, ImageDraw

def create_clean_pipe(width, height, color, output_path):
    """Create a solid colored pipe with no borders."""
    # Create image with transparency
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw solid rectangle - no borders, just fill
    draw.rectangle([0, 0, width-1, height-1], fill=color)
    
    img.save(output_path)
    print(f"Created {output_path}")

# Create pipe textures at @2x resolution (128x512)
# Using a bright green color for visibility
pipe_color = (34, 177, 76, 255)  # Bright green, fully opaque

create_clean_pipe(128, 512, pipe_color, 'FartyBird/FartyBird/Assets/Themes/chicken/pipe_top@2x.png')
create_clean_pipe(128, 512, pipe_color, 'FartyBird/FartyBird/Assets/Themes/chicken/pipe_bottom@2x.png')

print("\nClean pipe textures generated successfully!")
print("No borders, no hairlines - just solid green rectangles.")
