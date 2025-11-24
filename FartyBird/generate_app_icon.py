#!/usr/bin/env python3
"""
Generate app icon for Farty Bird in all required iOS sizes.
"""

from PIL import Image, ImageDraw, ImageFont
import os

# iOS app icon sizes (in points, need 2x and 3x for retina)
ICON_SIZES = [
    (20, [2, 3]),   # iPhone Notification
    (29, [2, 3]),   # iPhone Settings
    (40, [2, 3]),   # iPhone Spotlight
    (60, [2, 3]),   # iPhone App
    (76, [1, 2]),   # iPad App
    (83.5, [2]),    # iPad Pro App
    (1024, [1]),    # App Store
]

def create_app_icon(size, output_path):
    """Create a simple app icon with Farty Bird branding."""
    img = Image.new('RGBA', (size, size), (255, 200, 50, 255))  # Yellow/orange background
    draw = ImageDraw.Draw(img)
    
    # Draw a simple chicken silhouette (circle for body, triangle for beak)
    center_x, center_y = size // 2, size // 2
    body_radius = int(size * 0.35)
    
    # Body (circle)
    draw.ellipse(
        [center_x - body_radius, center_y - body_radius,
         center_x + body_radius, center_y + body_radius],
        fill=(255, 255, 255, 255),
        outline=(200, 150, 50, 255),
        width=max(2, size // 50)
    )
    
    # Eye
    eye_size = max(2, size // 20)
    eye_x = center_x + body_radius // 3
    eye_y = center_y - body_radius // 3
    draw.ellipse(
        [eye_x - eye_size, eye_y - eye_size,
         eye_x + eye_size, eye_y + eye_size],
        fill=(0, 0, 0, 255)
    )
    
    # Beak (triangle)
    beak_size = body_radius // 2
    beak_points = [
        (center_x + body_radius, center_y),
        (center_x + body_radius + beak_size, center_y - beak_size // 2),
        (center_x + body_radius + beak_size, center_y + beak_size // 2),
    ]
    draw.polygon(beak_points, fill=(255, 150, 0, 255))
    
    # Add "FB" text for smaller icons
    if size >= 60:
        try:
            font_size = max(12, size // 5)
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
        except:
            font = ImageFont.load_default()
        
        text = "FB"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        text_x = center_x - text_width // 2
        text_y = center_y + body_radius + max(5, size // 30)
        
        # Draw text with outline
        for dx, dy in [(-1,-1), (-1,1), (1,-1), (1,1)]:
            draw.text((text_x+dx, text_y+dy), text, font=font, fill=(200, 150, 50, 255))
        draw.text((text_x, text_y), text, font=font, fill=(255, 255, 255, 255))
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, 'PNG')
    print(f"Created: {output_path} ({size}x{size})")

def main():
    base_path = "FartyBird/FartyBird/Assets.xcassets/AppIcon.appiconset"
    
    print("\n=== Creating App Icons ===")
    
    for size_points, scales in ICON_SIZES:
        for scale in scales:
            size_pixels = int(size_points * scale)
            
            if size_points == 1024:
                # App Store icon (no scale suffix)
                filename = f"icon_{size_pixels}x{size_pixels}.png"
            else:
                # Regular icons
                filename = f"icon_{int(size_points)}x{int(size_points)}@{scale}x.png"
            
            output_path = os.path.join(base_path, filename)
            create_app_icon(size_pixels, output_path)
    
    print("\n✅ All app icons created successfully!")
    print("\nNote: You'll need to update Contents.json in the AppIcon.appiconset folder")
    print("to reference these new icon files.")

if __name__ == "__main__":
    main()
