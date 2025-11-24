#!/usr/bin/env python3
"""
Generate placeholder sound effects for Farty Bird game.
Creates simple beep/tone WAV files for testing.
"""

import wave
import struct
import math
import os

def generate_tone(frequency, duration, sample_rate=44100, amplitude=0.3):
    """Generate a simple sine wave tone."""
    num_samples = int(sample_rate * duration)
    samples = []
    
    for i in range(num_samples):
        # Generate sine wave
        value = amplitude * math.sin(2 * math.pi * frequency * i / sample_rate)
        # Convert to 16-bit integer
        samples.append(int(value * 32767))
    
    return samples

def generate_sweep(start_freq, end_freq, duration, sample_rate=44100, amplitude=0.3):
    """Generate a frequency sweep (chirp)."""
    num_samples = int(sample_rate * duration)
    samples = []
    
    for i in range(num_samples):
        # Linear frequency sweep
        t = i / sample_rate
        freq = start_freq + (end_freq - start_freq) * (t / duration)
        value = amplitude * math.sin(2 * math.pi * freq * t)
        # Apply envelope to avoid clicks
        envelope = min(1.0, i / (sample_rate * 0.01), (num_samples - i) / (sample_rate * 0.01))
        samples.append(int(value * envelope * 32767))
    
    return samples

def generate_noise_burst(duration, sample_rate=44100, amplitude=0.2):
    """Generate a short noise burst."""
    import random
    num_samples = int(sample_rate * duration)
    samples = []
    
    for i in range(num_samples):
        # Random noise
        value = amplitude * (random.random() * 2 - 1)
        # Apply envelope
        envelope = min(1.0, i / (sample_rate * 0.005), (num_samples - i) / (sample_rate * 0.02))
        samples.append(int(value * envelope * 32767))
    
    return samples

def save_wav(filename, samples, sample_rate=44100):
    """Save samples as a WAV file."""
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    
    with wave.open(filename, 'w') as wav_file:
        # Set parameters: 1 channel (mono), 2 bytes per sample, sample rate
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        # Write samples
        for sample in samples:
            wav_file.writeframes(struct.pack('<h', sample))
    
    print(f"Created: {filename}")

def main():
    base_path = "FartyBird/Assets/Sounds"
    
    print("\n=== Creating Sound Effects ===")
    
    # Fart sound - descending sweep with some wobble
    print("Creating fart sound...")
    fart_samples = []
    fart_samples.extend(generate_sweep(400, 150, 0.3, amplitude=0.25))
    save_wav(f"{base_path}/fart.wav", fart_samples)
    
    # Collision sound - short noise burst
    print("Creating collision sound...")
    collision_samples = generate_noise_burst(0.15, amplitude=0.3)
    save_wav(f"{base_path}/collision.wav", collision_samples)
    
    # Score sound - ascending tone
    print("Creating score sound...")
    score_samples = []
    score_samples.extend(generate_tone(523, 0.1, amplitude=0.2))  # C5
    score_samples.extend(generate_tone(659, 0.1, amplitude=0.2))  # E5
    save_wav(f"{base_path}/score.wav", score_samples)
    
    print("\n✅ All placeholder sound effects created successfully!")

if __name__ == "__main__":
    main()
