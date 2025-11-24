# Implementation Plan

- ✅ 1. Set up Xcode project and core structure
  - Create new iOS Game project in Xcode with SpriteKit template
  - Set deployment target to iOS 15.0
  - Configure project for iPhone and iPad support
  - Set up folder structure for Assets, Scenes, Managers, Models
  - Add swift-check dependency via Swift Package Manager
  - _Requirements: 10.1, 10.2, 13.5_

- ✅ 2. Implement data models and configuration
  - ✅ 2.1 Create GameConfiguration model with difficulty settings
    - Define Difficulty enum (easy, normal)
    - Implement configuration() method with gap sizes and spawn intervals
    - _Requirements: 6.1, 6.2, 6.3_

  - ✅ 2.2 Create GameState model
    - Define properties for score, playing state, character position
    - _Requirements: 4.1, 9.2_

  - ✅ 2.3 Create AssetConfiguration model
    - Define structure for theme paths and asset names
    - Make it Codable for JSON serialization
    - _Requirements: 11.1, 11.4_

  - ✅ 2.4 Create asset_config.json configuration file
    - Define chicken theme path and asset names
    - Place in Assets/Config directory
    - _Requirements: 11.4_

- ✅ 3. Implement ScoreManager singleton
  - ✅ 3.1 Create ScoreManager class with score tracking
    - Implement incrementScore(), getCurrentScore(), resetScore()
    - Implement getHighScore(), updateHighScore()
    - _Requirements: 4.1, 4.3, 4.4_

  - ✅ 3.2 Add UserDefaults persistence
    - Implement saveHighScore() and loadHighScore()
    - Handle missing high score (initialize to zero)
    - Handle storage unavailable errors gracefully
    - _Requirements: 5.1, 5.2, 5.3, 5.5_

  - ✅ 3.3 Write property test for high score persistence
    - **Property 13: High score persistence**
    - **Validates: Requirements 4.4, 5.1**

- ✅ 4. Implement AudioManager singleton
  - ✅ 4.1 Create AudioManager class with sound playback
    - Implement playFartSound(), playCollisionSound(), playScoreSound()
    - Implement setMuted() and isMuted()
    - Use SKAction.playSoundFileNamed for playback
    - _Requirements: 12.1, 12.2, 12.3, 12.4_

  - ✅ 4.2 Add mute state persistence
    - Implement saveMuteState() and loadMuteState() using UserDefaults
    - _Requirements: 12.5_

  - ✅ 4.3 Write property test for mute functionality
    - **Property 31: Mute functionality**
    - **Validates: Requirements 12.4**

  - ✅ 4.4 Write property test for mute persistence
    - **Property 32: Mute setting persistence**
    - **Validates: Requirements 12.5**

- ✅ 5. Implement AssetManager singleton
  - ✅ 5.1 Create AssetManager class with theme loading
    - Implement loadCharacterSprites(), loadObstacleSprites(), loadBackgroundSprites(), loadUISprites()
    - Implement setCurrentTheme() and getCurrentTheme()
    - Load asset_config.json on initialization
    - _Requirements: 11.1, 11.2, 11.4_

  - ✅ 5.2 Add placeholder graphics for missing assets
    - Create colored rectangle textures as fallbacks
    - Log warnings when assets are missing
    - _Requirements: 11.5_

  - ✅ 5.3 Write property test for asset loading
    - **Property 25: Asset loading from theme directory**
    - **Validates: Requirements 11.1**

  - ✅ 5.4 Write property test for missing asset handling
    - **Property 27: Missing asset handling**
    - **Validates: Requirements 11.5**

- ✅ 6. Implement PhysicsManager
  - ✅ 6.1 Define PhysicsCategory struct with bit masks
    - Define categories for character, obstacle, ground, scoreZone
    - _Requirements: 3.3_

  - ✅ 6.2 Create PhysicsManager class
    - Implement setupPhysicsWorld() to configure physics
    - Implement handleCollision() for collision detection
    - _Requirements: 3.1, 3.2, 3.3_

- ✅ 7. Implement CharacterNode
  - ✅ 7.1 Create CharacterNode class extending SKSpriteNode
    - Define CharacterState enum (idle, farting, falling, dead)
    - Add isAlive and currentState properties
    - Set up physics body with circular shape
    - _Requirements: 1.1, 1.2, 7.1_

  - ✅ 7.2 Implement character physics methods
    - Implement applyFartThrust() to apply upward velocity
    - Implement gravity handling in update loop
    - Implement top boundary clamping
    - _Requirements: 1.1, 1.2, 1.3_

  - ✅ 7.3 Write property test for thrust application
    - **Property 1: Tap applies upward thrust**
    - **Validates: Requirements 1.1**

  - ✅ 7.4 Write property test for gravity
    - **Property 2: Gravity applies when no input**
    - **Validates: Requirements 1.2**

  - ✅ 7.5 Write property test for top boundary clamping
    - **Property 3: Top boundary clamping**
    - **Validates: Requirements 1.3**

  - ✅ 7.6 Implement character animations
    - Implement playIdleAnimation() using SKAction
    - Implement playFartAnimation() using SKAction
    - Implement playFallingAnimation() using SKAction
    - Load animation textures from AssetManager
    - _Requirements: 7.1, 7.2, 7.3_

  - ✅ 7.7 Write property test for animation state matching
    - **Property 17: Animation state matches character state**
    - **Validates: Requirements 7.1, 7.2, 7.3**

- ✅ 8. Create fart particle effect
  - ✅ 8.1 Create FartParticles.sks in Xcode
    - Use Particle Emitter Editor with Smoke template
    - Customize colors (white/yellow), size, emission rate
    - Limit max particles to 50
    - _Requirements: 7.7_

  - ✅ 8.2 Add particle effect to character fart action
    - Load SKEmitterNode from FartParticles.sks
    - Position at character location
    - Add to scene on fart action
    - Set lifetime to auto-remove
    - _Requirements: 7.7_

  - ✅ 8.3 Write property test for particle effect creation
    - **Property 19: Fart particle effect creation**
    - **Validates: Requirements 7.7**

- ✅ 9. Implement ObstacleManager
  - ✅ 9.1 Create ObstacleNode class extending SKNode
    - Create top and bottom pipe sprites
    - Add score zone sensor between pipes
    - Set up physics bodies
    - _Requirements: 2.4, 4.1_

  - ✅ 9.2 Create ObstacleManager class
    - Implement spawnObstacle() with gap size parameter
    - Implement generateNextObstacle() with random gap position
    - Implement updateObstacles() for scrolling
    - Implement removeOffscreenObstacles()
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5_

  - ✅ 9.3 Write property test for obstacle spawning
    - **Property 4: Regular obstacle spawning**
    - **Validates: Requirements 2.1**

  - ✅ 9.4 Write property test for constant scroll speed
    - **Property 5: Constant obstacle scroll speed**
    - **Validates: Requirements 2.2**

  - ✅ 9.5 Write property test for offscreen cleanup
    - **Property 6: Offscreen obstacle cleanup**
    - **Validates: Requirements 2.3**

  - ✅ 9.6 Write property test for gap size consistency
    - **Property 7: Obstacle gap size consistency**
    - **Validates: Requirements 2.4**

  - ✅ 9.7 Write property test for gap position variation
    - **Property 8: Gap position variation**
    - **Validates: Requirements 2.5**

- ✅ 10. Implement GameScene
  - ✅ 10.1 Create GameScene class extending SKScene
    - Set up scene with background, ground, character
    - Initialize ObstacleManager
    - Set up physics world and contact delegate
    - _Requirements: 1.5, 8.2, 8.3_

  - ✅ 10.2 Implement game loop in update()
    - Update character physics
    - Update obstacle positions
    - Remove offscreen obstacles
    - Check for scoring (character passing through gap)
    - _Requirements: 1.5, 2.2, 2.3, 4.1_

  - ✅ 10.3 Implement touch handling
    - Detect tap input
    - Call character.applyFartThrust()
    - Trigger fart animation and particle effect
    - Play fart sound via AudioManager
    - _Requirements: 1.1, 7.2, 7.7, 12.1_

  - ✅ 10.4 Implement collision detection
    - Implement SKPhysicsContactDelegate methods
    - Detect character-obstacle collisions
    - Detect character-ground collisions
    - Detect character-scoreZone contacts for scoring
    - _Requirements: 3.1, 3.2, 4.1_

  - ✅ 10.5 Write property test for collision triggering game over
    - **Property 9: Collision triggers game over**
    - **Validates: Requirements 3.1**

  - ✅ 10.6 Write property test for score increment
    - **Property 11: Passing obstacle increments score**
    - **Validates: Requirements 4.1**

  - ✅ 10.7 Implement game over sequence
    - Stop all game object movement
    - Play character falling animation
    - Play collision sound
    - Spawn tombstone at character position
    - Display score on tombstone
    - Transition to GameOverScene after delay
    - _Requirements: 3.4, 3.5, 7.4, 7.5, 7.6, 12.2_

  - ✅ 10.8 Write property test for game over stopping movement
    - **Property 10: Game over stops movement**
    - **Validates: Requirements 3.4**

  - ✅ 10.9 Write property test for death sequence
    - **Property 18: Death sequence completion**
    - **Validates: Requirements 7.4, 7.5**

  - ✅ 10.10 Implement scrolling background
    - Create two background sprites for seamless scrolling
    - Update positions in update() loop
    - Reset position when off-screen
    - _Requirements: 8.2_

  - ✅ 10.11 Write property test for background scrolling
    - **Property 20: Background scrolling**
    - **Validates: Requirements 8.2**

  - ✅ 10.12 Implement scrolling ground
    - Create two ground sprites for seamless scrolling
    - Scroll at same speed as obstacles
    - Reset position when off-screen
    - _Requirements: 8.3_

  - ✅ 10.13 Write property test for ground scrolling
    - **Property 21: Ground scrolling**
    - **Validates: Requirements 8.3**

  - ✅ 10.14 Add score display label
    - Create SKLabelNode for current score
    - Update on score increment
    - Position at top center of screen
    - _Requirements: 4.2_

  - ✅ 10.15 Implement difficulty configuration
    - Load GameConfiguration based on selected difficulty
    - Apply gap size and spawn interval to ObstacleManager
    - _Requirements: 6.2, 6.3_

  - ✅ 10.16 Write property test for easy mode gap size
    - **Property 14: Easy mode gap size increase**
    - **Validates: Requirements 6.2**

  - ✅ 10.17 Write property test for easy mode spawn interval
    - **Property 15: Easy mode spawn interval increase**
    - **Validates: Requirements 6.3**

- [x] 11. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 12. Implement MenuScene
  - [x] 12.1 Create MenuScene class extending SKScene
    - Add title logo sprite
    - Add play button sprite
    - Add settings button sprite
    - _Requirements: 9.1_

  - [x] 12.2 Implement touch handling
    - Detect tap on play button
    - Transition to GameScene
    - Detect tap on settings button
    - Transition to SettingsScene
    - _Requirements: 9.2_

- [x] 13. Implement GameOverScene
  - [x] 13.1 Create GameOverScene class extending SKScene
    - Display "Game Over" text
    - Display current score
    - Display high score
    - Add restart instruction text
    - _Requirements: 4.5, 9.3_

  - [x] 13.2 Implement high score update logic
    - Compare current score with high score
    - Update high score via ScoreManager if exceeded
    - _Requirements: 4.3, 4.4_

  - [x] 13.3 Write property test for high score comparison
    - **Property 12: High score comparison**
    - **Validates: Requirements 4.3**

  - [x] 13.4 Implement touch handling
    - Detect tap anywhere on screen
    - Reset score to zero
    - Transition back to GameScene
    - _Requirements: 9.4, 9.5_

  - [x] 13.5 Write property test for score reset
    - **Property 22: Score reset on new game**
    - **Validates: Requirements 9.5**

- [x] 14. Implement SettingsScene
  - [x] 14.1 Create SettingsScene class extending SKScene
    - Add difficulty selection buttons (Easy, Normal)
    - Add sound toggle button
    - Add back button
    - _Requirements: 6.5, 12.4_

  - [x] 14.2 Implement difficulty selection
    - Detect tap on difficulty buttons
    - Update GameConfiguration
    - Save to UserDefaults
    - Provide visual feedback for selected difficulty
    - _Requirements: 6.1, 6.4_

  - [x] 14.3 Write property test for difficulty persistence
    - **Property 16: Difficulty persistence**
    - **Validates: Requirements 6.4**

  - [x] 14.4 Implement sound toggle
    - Detect tap on sound button
    - Toggle mute state via AudioManager
    - Update button icon (sound on/off)
    - _Requirements: 12.4, 12.5_

  - [x] 14.5 Implement back button
    - Detect tap on back button
    - Transition back to MenuScene
    - _Requirements: 6.5_

- [x] 15. Implement GameViewController
  - [x] 15.1 Create GameViewController class
    - Set up SKView
    - Configure view properties (ignoresSiblingOrder, showsFPS, showsNodeCount for debug)
    - _Requirements: 13.5_

  - [x] 15.2 Implement scene presentation
    - Present MenuScene on viewDidLoad
    - Configure scene scale mode for multi-device support
    - _Requirements: 9.1, 10.3, 10.5_

  - [x] 15.3 Write property test for screen size scaling
    - **Property 23: Screen size scaling**
    - **Validates: Requirements 10.3**

  - [x] 15.4 Write property test for aspect ratio preservation
    - **Property 24: Aspect ratio preservation**
    - **Validates: Requirements 10.5**

  - [x] 15.3 Handle iOS lifecycle events
    - Pause game when app enters background
    - Resume when app becomes active
    - _Requirements: 13.1_

- [x] 16. Add placeholder assets
  - [x] 16.1 Create placeholder chicken sprites
    - Create colored rectangles for idle, fart, falling animations
    - Save as PNG files in Assets/Themes/chicken/
    - _Requirements: 7.1, 7.2, 7.3, 11.5_

  - [x] 16.2 Create placeholder obstacle sprites
    - Create colored rectangles for pipe top and bottom
    - Save as PNG files in Assets/Themes/chicken/
    - _Requirements: 2.4, 11.5_

  - [x] 16.3 Create placeholder background and ground
    - Create simple colored backgrounds
    - Save as PNG files in Assets/Themes/chicken/
    - _Requirements: 8.2, 8.3, 11.5_

  - [x] 16.4 Create placeholder UI sprites
    - Create simple number sprites (0-9)
    - Create play button, title logo, settings icon
    - Create sound on/off icons
    - Save as PNG files in Assets/UI/
    - _Requirements: 9.1, 12.4_

  - [x] 16.5 Create placeholder tombstone sprite
    - Create simple tombstone graphic
    - Save as PNG file in Assets/Themes/chicken/
    - _Requirements: 7.5_

- [x] 17. Add placeholder sound effects
  - [x] 17.1 Create or find placeholder sound files
    - Add fart.wav, collision.wav, score.wav to Assets/Sounds/
    - Use simple beep sounds or royalty-free effects
    - _Requirements: 12.1, 12.2, 12.3_

- [x] 18. Configure app metadata
  - [x] 18.1 Set up app icon
    - Create app icon in all required sizes
    - Add to Assets.xcassets
    - _Requirements: Deployment_

  - [x] 18.2 Create launch screen
    - Design simple launch screen with title
    - Configure in LaunchScreen.storyboard
    - _Requirements: Deployment_

  - [x] 18.3 Configure Info.plist
    - Set display name to "Farty Bird"
    - Set supported orientations (portrait only)
    - Set status bar style
    - _Requirements: 10.1, 10.2_

- [ ] 19. Final testing and polish
  - [ ] 19.1 Test on iPhone simulator
    - Verify all gameplay mechanics work
    - Test scene transitions
    - Test persistence (high score, difficulty, mute)
    - _Requirements: 10.1_

  - [ ] 19.2 Test on iPad simulator
    - Verify scaling works correctly
    - Test all gameplay mechanics
    - _Requirements: 10.2, 10.3, 10.5_

  - [ ] 19.3 Run all property-based tests
    - Execute full test suite with 100 iterations per property
    - Fix any failing tests
    - _Requirements: All testable requirements_

  - [ ] 19.4 Performance testing
    - Verify 60fps on target devices
    - Check memory usage stays under 100MB
    - Test app launch time
    - _Requirements: 13.1, 13.2, 13.4_

- [ ] 20. Final Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
