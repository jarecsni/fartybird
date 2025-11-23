# Design Document

## Overview

Farty Bird is a 2D side-scrolling game built using Apple's SpriteKit framework for iOS. The game follows a scene-based architecture where different game states (menu, gameplay, game over) are represented as distinct SKScene subclasses. The design emphasises modularity, particularly in the asset system, to enable easy theme swapping without code changes.

The core gameplay loop involves physics-based character movement, procedural obstacle generation, collision detection, and score tracking. All visual elements use pixel art styling, and the game maintains 60fps performance through SpriteKit's hardware-accelerated rendering.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GameViewController                       │
│  (Manages SKView, handles scene transitions)                │
└────────────────────┬────────────────────────────────────────┘
                     │
        ┌────────────┴────────────┬──────────────────┐
        │                         │                  │
┌───────▼────────┐    ┌──────────▼────────┐  ┌─────▼──────────┐
│  MenuScene     │    │   GameScene       │  │ GameOverScene  │
│  (Start menu)  │    │  (Active gameplay)│  │ (Results)      │
└────────────────┘    └───────────────────┘  └────────────────┘
                              │
                ┌─────────────┼─────────────┐
                │             │             │
        ┌───────▼──────┐ ┌───▼────┐ ┌─────▼──────┐
        │ CharacterNode│ │Obstacle│ │ScoreManager│
        │              │ │Manager │ │            │
        └──────────────┘ └────────┘ └────────────┘
```

### Scene-Based State Management

The game uses SpriteKit's scene system to manage different game states:

- **MenuScene**: Displays title, play button, settings button
- **GameScene**: Active gameplay with character, obstacles, scoring
- **GameOverScene**: Shows final score, high score, restart option
- **SettingsScene**: Difficulty and audio settings

Scene transitions are handled by the GameViewController using `SKView.presentScene(_:transition:)`.

### Component Structure

**GameViewController**
- Manages the SKView instance
- Handles scene transitions
- Coordinates with iOS lifecycle events

**GameScene (Primary gameplay scene)**
- Character management and physics
- Obstacle spawning and movement
- Collision detection
- Score tracking
- Particle effects
- Background scrolling

**Supporting Managers**
- **AssetManager**: Loads sprites from current theme pack
- **ScoreManager**: Handles score persistence via UserDefaults
- **AudioManager**: Manages sound effects and mute state
- **PhysicsManager**: Defines physics categories and collision handling

## Components and Interfaces

### CharacterNode (SKSpriteNode subclass)

Represents the player-controlled chicken character.

```swift
class CharacterNode: SKSpriteNode {
    // Animation management
    func playIdleAnimation()
    func playFartAnimation()
    func playFallingAnimation()
    
    // Physics
    func applyFartThrust()
    func applyGravity()
    
    // State
    var isAlive: Bool
    var currentState: CharacterState
}

enum CharacterState {
    case idle
    case farting
    case falling
    case dead
}
```

### ObstacleManager

Handles procedural generation and lifecycle of pipe obstacles.

```swift
class ObstacleManager {
    // Spawning
    func spawnObstacle(at position: CGPoint, gapSize: CGFloat)
    func generateNextObstacle()
    
    // Movement
    func updateObstacles(deltaTime: TimeInterval)
    func removeOffscreenObstacles()
    
    // Configuration
    var spawnInterval: TimeInterval
    var scrollSpeed: CGFloat
    var gapSize: CGFloat
}
```

### AssetManager (Singleton)

Loads sprites from the current theme directory.

```swift
class AssetManager {
    static let shared = AssetManager()
    
    // Asset loading
    func loadCharacterSprites(for theme: String) -> [String: SKTexture]
    func loadObstacleSprites(for theme: String) -> [String: SKTexture]
    func loadBackgroundSprites(for theme: String) -> [String: SKTexture]
    func loadUISprites() -> [String: SKTexture]
    
    // Theme management
    func setCurrentTheme(_ theme: String)
    func getCurrentTheme() -> String
    
    // Configuration
    private var assetConfig: AssetConfiguration
}

struct AssetConfiguration: Codable {
    var currentTheme: String
    var assetPaths: [String: String]
}
```

### ScoreManager (Singleton)

Manages score tracking and persistence.

```swift
class ScoreManager {
    static let shared = ScoreManager()
    
    // Score management
    func incrementScore()
    func getCurrentScore() -> Int
    func resetScore()
    
    // High score
    func getHighScore() -> Int
    func updateHighScore(_ score: Int)
    
    // Persistence
    private func saveHighScore()
    private func loadHighScore()
}
```

### AudioManager (Singleton)

Handles sound effect playback and mute state.

```swift
class AudioManager {
    static let shared = AudioManager()
    
    // Sound playback
    func playFartSound()
    func playCollisionSound()
    func playScoreSound()
    
    // Settings
    func setMuted(_ muted: Bool)
    func isMuted() -> Bool
    
    // Persistence
    private func saveMuteState()
    private func loadMuteState()
}
```

### PhysicsManager

Defines physics categories and collision handling.

```swift
struct PhysicsCategory {
    static let none: UInt32 = 0
    static let character: UInt32 = 0b1      // 1
    static let obstacle: UInt32 = 0b10      // 2
    static let ground: UInt32 = 0b100       // 4
    static let scoreZone: UInt32 = 0b1000   // 8
}

class PhysicsManager {
    // Collision detection
    func setupPhysicsWorld(for scene: SKScene)
    func handleCollision(between nodeA: SKNode, and nodeB: SKNode)
}
```

## Data Models

### GameConfiguration

Stores difficulty settings and game parameters.

```swift
struct GameConfiguration: Codable {
    var difficulty: Difficulty
    var obstacleGapSize: CGFloat
    var obstacleSpawnInterval: TimeInterval
    var scrollSpeed: CGFloat
    var characterThrust: CGFloat
    var gravity: CGFloat
    
    enum Difficulty: String, Codable {
        case easy
        case normal
        
        func configuration() -> GameConfiguration {
            switch self {
            case .easy:
                return GameConfiguration(
                    difficulty: .easy,
                    obstacleGapSize: 180,
                    obstacleSpawnInterval: 2.4,
                    scrollSpeed: 150,
                    characterThrust: 350,
                    gravity: -9.8
                )
            case .normal:
                return GameConfiguration(
                    difficulty: .normal,
                    obstacleGapSize: 140,
                    obstacleSpawnInterval: 2.0,
                    scrollSpeed: 150,
                    characterThrust: 350,
                    gravity: -9.8
                )
            }
        }
    }
}
```

### GameState

Tracks current game session state.

```swift
struct GameState {
    var currentScore: Int
    var isPlaying: Bool
    var isPaused: Bool
    var characterPosition: CGPoint
    var obstaclesOnScreen: [ObstacleNode]
}
```

### AssetPack

Defines the structure of a theme asset pack.

```swift
struct AssetPack {
    var themeName: String
    var characterSprites: CharacterSprites
    var obstacleSprites: ObstacleSprites
    var backgroundSprites: BackgroundSprites
    var uiSprites: UISprites
}

struct CharacterSprites {
    var idle: [SKTexture]
    var fart: [SKTexture]
    var falling: [SKTexture]
}

struct ObstacleSprites {
    var pipeTop: SKTexture
    var pipeBottom: SKTexture
}

struct BackgroundSprites {
    var sky: SKTexture
    var ground: SKTexture
}

struct UISprites {
    var numbers: [SKTexture]  // 0-9
    var playButton: SKTexture
    var titleLogo: SKTexture
    var settingsIcon: SKTexture
    var soundOnIcon: SKTexture
    var soundOffIcon: SKTexture
}
```

## Correctness Properties


*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Core Gameplay Properties

**Property 1: Tap applies upward thrust**
*For any* game state where the character is alive, tapping the screen should apply positive upward velocity to the character.
**Validates: Requirements 1.1**

**Property 2: Gravity applies when no input**
*For any* game state with no tap input, the character's vertical velocity should decrease over time due to gravity.
**Validates: Requirements 1.2**

**Property 3: Top boundary clamping**
*For any* character position and upward velocity, the character's y-position should never exceed the top screen boundary.
**Validates: Requirements 1.3**

### Obstacle System Properties

**Property 4: Regular obstacle spawning**
*For any* game session, obstacles should spawn at intervals matching the configured spawn interval (within a small tolerance).
**Validates: Requirements 2.1**

**Property 5: Constant obstacle scroll speed**
*For any* set of obstacles on screen, all obstacles should move at the same constant speed.
**Validates: Requirements 2.2**

**Property 6: Offscreen obstacle cleanup**
*For any* obstacle that moves beyond the left screen boundary, that obstacle should be removed from the scene.
**Validates: Requirements 2.3**

**Property 7: Obstacle gap size consistency**
*For any* generated obstacle, the vertical gap between top and bottom pipes should match the configured gap size.
**Validates: Requirements 2.4**

**Property 8: Gap position variation**
*For any* sequence of generated obstacles, the gap positions should vary (not all at the same vertical position).
**Validates: Requirements 2.5**

### Collision and Game Over Properties

**Property 9: Collision triggers game over**
*For any* collision between the character and an obstacle, the game state should transition to game over.
**Validates: Requirements 3.1**

**Property 10: Game over stops movement**
*For any* game over event, all game objects (obstacles, background, ground) should stop moving.
**Validates: Requirements 3.4**

### Scoring Properties

**Property 11: Passing obstacle increments score**
*For any* obstacle gap that the character successfully passes through, the score should increment by exactly one.
**Validates: Requirements 4.1**

**Property 12: High score comparison**
*For any* game session end, if the current score exceeds the stored high score, the high score should be updated.
**Validates: Requirements 4.3**

**Property 13: High score persistence**
*For any* high score update, the new high score should be saved to persistent storage and correctly loaded on next app launch.
**Validates: Requirements 4.4, 5.1**

### Difficulty Properties

**Property 14: Easy mode gap size increase**
*For any* obstacle generated in easy difficulty mode, the gap size should be 30% larger than normal mode.
**Validates: Requirements 6.2**

**Property 15: Easy mode spawn interval increase**
*For any* obstacle spawn in easy difficulty mode, the time interval between spawns should be 20% longer than normal mode.
**Validates: Requirements 6.3**

**Property 16: Difficulty persistence**
*For any* difficulty setting change, the new setting should be saved to persistent storage and correctly loaded on next app launch.
**Validates: Requirements 6.4**

### Animation Properties

**Property 17: Animation state matches character state**
*For any* character state (idle, farting, falling), the currently playing animation should match that state.
**Validates: Requirements 7.1, 7.2, 7.3**

**Property 18: Death sequence completion**
*For any* collision event, the character should fall to the ground, then a tombstone should appear at the character's final position.
**Validates: Requirements 7.4, 7.5**

**Property 19: Fart particle effect creation**
*For any* fart action, a particle emitter node should be created and added to the scene at the character's position.
**Validates: Requirements 7.7**

### Visual Presentation Properties

**Property 20: Background scrolling**
*For any* active gameplay state, the background should continuously scroll from right to left.
**Validates: Requirements 8.2**

**Property 21: Ground scrolling**
*For any* active gameplay state, the ground texture should continuously scroll at the same speed as obstacles.
**Validates: Requirements 8.3**

### Game State Properties

**Property 22: Score reset on new game**
*For any* new game session start, the current score should be reset to zero.
**Validates: Requirements 9.5**

### Multi-Device Properties

**Property 23: Screen size scaling**
*For any* device screen size, the game view should scale appropriately while maintaining gameplay mechanics.
**Validates: Requirements 10.3**

**Property 24: Aspect ratio preservation**
*For any* screen size, sprite aspect ratios should be preserved (no distortion).
**Validates: Requirements 10.5**

### Asset System Properties

**Property 25: Asset loading from theme directory**
*For any* theme selection, all sprites should be loaded from that theme's designated directory.
**Validates: Requirements 11.1**

**Property 26: Theme switching**
*For any* theme change, the game should load and display sprites from the new theme's asset pack.
**Validates: Requirements 11.3**

**Property 27: Missing asset handling**
*For any* missing asset file, the game should continue functioning without crashing (using placeholder graphics).
**Validates: Requirements 11.5**

### Audio Properties

**Property 28: Fart sound playback**
*For any* fart action when audio is not muted, the fart sound effect should play.
**Validates: Requirements 12.1**

**Property 29: Collision sound playback**
*For any* collision event when audio is not muted, the collision sound effect should play.
**Validates: Requirements 12.2**

**Property 30: Score sound playback**
*For any* score increment when audio is not muted, the scoring sound effect should play.
**Validates: Requirements 12.3**

**Property 31: Mute functionality**
*For any* sound effect trigger when audio is muted, no sound should play.
**Validates: Requirements 12.4**

**Property 32: Mute setting persistence**
*For any* mute setting change, the new setting should be saved to persistent storage and correctly loaded on next app launch.
**Validates: Requirements 12.5**

## Error Handling

### Asset Loading Errors

When asset files are missing or corrupted:
- Use placeholder colored rectangles with the expected dimensions
- Log warnings to console for debugging
- Continue game execution without crashing
- Display a warning message in debug builds

### Persistence Errors

When UserDefaults is unavailable or fails:
- Use in-memory defaults (high score = 0, difficulty = normal, mute = false)
- Log errors to console
- Continue game execution
- Retry persistence on next state change

### Physics Edge Cases

- Character stuck in obstacle: Force game over immediately
- Character velocity exceeds maximum: Clamp to reasonable maximum
- Obstacle spawn overlap: Adjust spawn timing to prevent overlap

### Memory Management

- Remove obstacles from scene when off-screen
- Limit particle emitter lifetime to prevent accumulation
- Unload unused textures when switching themes
- Use texture atlases to reduce memory footprint

## Testing Strategy

### Unit Testing

Unit tests will cover:
- ScoreManager logic (increment, high score comparison, persistence)
- AssetManager theme loading and switching
- AudioManager mute state and persistence
- GameConfiguration difficulty calculations
- Collision detection logic
- Obstacle spawning intervals and positioning

### Property-Based Testing

Property-based tests will use **swift-check** (Swift's QuickCheck implementation) to verify the correctness properties defined above.

**Configuration:**
- Each property test will run a minimum of 100 iterations
- Tests will generate random game states, positions, velocities, and configurations
- Each property test will be tagged with a comment referencing the design document property

**Example property test structure:**
```swift
// Feature: farty-bird, Property 1: Tap applies upward thrust
func testTapAppliesUpwardThrust() {
    property("Tapping applies positive upward velocity") <- forAll { (gameState: GameState) in
        let character = CharacterNode()
        character.velocity = gameState.velocity
        
        character.applyFartThrust()
        
        return character.velocity.dy > gameState.velocity.dy
    }
}
```

**Property test generators:**
- Random game states (playing, paused, game over)
- Random character positions within screen bounds
- Random velocities (positive and negative)
- Random obstacle configurations
- Random difficulty settings
- Random theme selections

### Integration Testing

Integration tests will verify:
- Scene transitions (menu → game → game over)
- Physics interactions between character and obstacles
- Score updates triggering UI changes
- Audio playback coordination with game events
- Asset loading and theme switching end-to-end

### Manual Testing

Manual testing will focus on:
- Visual quality and animation smoothness
- Audio timing and quality
- Touch responsiveness
- Performance on different devices (iPhone, iPad)
- Edge cases like rapid tapping, device rotation

## Implementation Notes

### SpriteKit Particle System

Fart particle effects will be created using Xcode's Particle Emitter Editor:
1. Create a new SpriteKit Particle File in Xcode
2. Use the "Smoke" template as a starting point
3. Customize colors (white/yellow tones), particle size, and emission rate
4. Save as `FartParticles.sks`
5. Load in code: `SKEmitterNode(fileNamed: "FartParticles")`

### Physics Configuration

SpriteKit physics will be configured as follows:
- Character: Dynamic body with circular physics shape
- Obstacles: Static bodies with rectangular physics shapes
- Ground: Static body spanning screen width
- Score zones: Sensor bodies (no collision, only detection)

### Performance Optimization

- Use texture atlases for all sprites to reduce draw calls
- Batch similar sprites together
- Limit particle emitter max particles to 50
- Remove nodes from scene when off-screen
- Use `SKAction.repeatForever()` for continuous animations
- Disable unnecessary physics calculations on static objects

### Asset Organization

```
FartyBird/
  Assets/
    Themes/
      chicken/
        character_idle@2x.png
        character_fart@2x.png
        character_falling@2x.png
        pipe_top@2x.png
        pipe_bottom@2x.png
        background_sky@2x.png
        ground@2x.png
        tombstone@2x.png
      spaceman/
        [same structure]
    UI/
      numbers@2x.png
      button_play@2x.png
      title_logo@2x.png
      icon_settings@2x.png
      icon_sound_on@2x.png
      icon_sound_off@2x.png
    Sounds/
      fart.wav
      collision.wav
      score.wav
    Particles/
      FartParticles.sks
    Config/
      asset_config.json
```

### Configuration File Format

`asset_config.json`:
```json
{
  "currentTheme": "chicken",
  "themes": {
    "chicken": {
      "path": "Themes/chicken",
      "displayName": "Farty Chicken"
    },
    "spaceman": {
      "path": "Themes/spaceman",
      "displayName": "Farty Spaceman"
    }
  },
  "assetNames": {
    "characterIdle": "character_idle",
    "characterFart": "character_fart",
    "characterFalling": "character_falling",
    "pipeTop": "pipe_top",
    "pipeBottom": "pipe_bottom",
    "backgroundSky": "background_sky",
    "ground": "ground",
    "tombstone": "tombstone"
  }
}
```

## Dependencies

- **iOS SDK**: iOS 15.0+
- **SpriteKit**: Built-in framework for 2D game rendering
- **swift-check**: Property-based testing library (dev dependency)
- **XCTest**: Unit testing framework (built-in)

## Deployment Considerations

### App Store Requirements

- App icon in all required sizes (1024x1024 for App Store, various sizes for device)
- Launch screen
- Privacy policy (if collecting any data)
- Age rating (likely 4+ or 9+ depending on humor level)
- Screenshots for iPhone and iPad

### Build Configuration

- Enable bitcode for App Store submission
- Set deployment target to iOS 15.0
- Configure code signing with appropriate provisioning profile
- Use release build configuration for App Store builds

### Version 1.0 Scope

The initial release will include:
- Core gameplay mechanics
- Two difficulty levels
- High score persistence
- Sound effects with mute option
- One theme (chicken)
- iPhone and iPad support

Future versions will add additional themes, power-ups, and enhanced features as outlined in FUTURE.md.
