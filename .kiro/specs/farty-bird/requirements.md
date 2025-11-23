# Requirements Document

## Introduction

Farty Bird is a Flappy Bird-inspired iOS game featuring a comic chicken that uses flatulence to stay airborne. The game provides simple tap-to-play mechanics with adjustable difficulty, persistent scoring, and a modular asset system that allows for easy theme changes. The game targets iOS devices including iPhone and iPad.

## Glossary

- **Game System**: The complete Farty Bird iOS application
- **Player**: The user playing the game
- **Character**: The controllable chicken sprite
- **Fart Action**: The upward thrust mechanic triggered by screen tap
- **Obstacle**: Vertical pipes or barriers the Character must navigate through
- **Game Session**: A single playthrough from start to game over
- **Score**: Points accumulated during a Game Session by passing Obstacles
- **High Score**: The highest Score achieved across all Game Sessions, stored persistently
- **Difficulty Level**: The current challenge setting affecting Obstacle spacing and frequency
- **Asset Pack**: A collection of themed sprites that can be swapped (e.g., chicken theme, spaceman theme)
- **SpriteKit**: Apple's 2D game engine framework for iOS

## Requirements

### Requirement 1: Core Gameplay Mechanics

**User Story:** As a player, I want to control a chicken by tapping the screen to make it fart and fly upward, so that I can navigate through obstacles and stay airborne.

#### Acceptance Criteria

1. WHEN the Player taps the screen, THE Game System SHALL apply upward thrust to the Character
2. WHILE no tap input is received, THE Game System SHALL apply downward gravity to the Character
3. WHEN the Character moves beyond the top screen boundary, THE Game System SHALL limit the Character position to remain visible
4. WHEN the Character moves beyond the bottom screen boundary, THE Game System SHALL trigger game over
5. THE Game System SHALL update Character position at 60 frames per second

### Requirement 2: Obstacle System

**User Story:** As a player, I want obstacles to appear that I must navigate through, so that the game provides challenge and scoring opportunities.

#### Acceptance Criteria

1. WHEN a Game Session starts, THE Game System SHALL generate Obstacles at regular intervals
2. THE Game System SHALL scroll Obstacles from right to left at constant speed
3. WHEN an Obstacle moves beyond the left screen boundary, THE Game System SHALL remove that Obstacle from the game
4. THE Game System SHALL create Obstacles with a vertical gap that allows the Character to pass through
5. THE Game System SHALL position the gap at varying vertical positions for each Obstacle

### Requirement 3: Collision Detection

**User Story:** As a player, I want the game to detect when my chicken hits an obstacle or the ground, so that the game ends appropriately.

#### Acceptance Criteria

1. WHEN the Character collides with an Obstacle, THE Game System SHALL trigger game over
2. WHEN the Character collides with the ground, THE Game System SHALL trigger game over
3. THE Game System SHALL use sprite boundary detection for collision calculations
4. WHEN game over is triggered, THE Game System SHALL stop all game object movement
5. WHEN game over is triggered, THE Game System SHALL display the game over screen

### Requirement 4: Scoring System

**User Story:** As a player, I want to earn points by successfully passing through obstacles, so that I can track my performance and compete with my previous scores.

#### Acceptance Criteria

1. WHEN the Character successfully passes through an Obstacle gap, THE Game System SHALL increment the Score by one point
2. THE Game System SHALL display the current Score during gameplay
3. WHEN a Game Session ends, THE Game System SHALL compare the current Score with the stored High Score
4. WHEN the current Score exceeds the High Score, THE Game System SHALL update and persist the new High Score
5. THE Game System SHALL display both current Score and High Score on the game over screen

### Requirement 5: Persistent Data Storage

**User Story:** As a player, I want my high score to be saved between game sessions, so that I can track my best performance over time.

#### Acceptance Criteria

1. WHEN the Game System launches, THE Game System SHALL load the stored High Score from device storage
2. WHEN a new High Score is achieved, THE Game System SHALL save the High Score to device storage immediately
3. WHEN no stored High Score exists, THE Game System SHALL initialise the High Score to zero
4. THE Game System SHALL use iOS UserDefaults for High Score persistence
5. WHEN the device storage is unavailable, THE Game System SHALL continue functioning with High Score set to zero

### Requirement 6: Difficulty Adjustment

**User Story:** As a player, I want the game difficulty to be adjustable, so that I can choose a challenge level appropriate to my skill.

#### Acceptance Criteria

1. THE Game System SHALL provide at least two Difficulty Levels (easy and normal)
2. WHEN easy Difficulty Level is selected, THE Game System SHALL increase the vertical gap size in Obstacles by 30 percent
3. WHEN easy Difficulty Level is selected, THE Game System SHALL increase the time interval between Obstacles by 20 percent
4. THE Game System SHALL persist the selected Difficulty Level between Game Sessions
5. THE Game System SHALL provide a settings interface to change Difficulty Level

### Requirement 7: Character Animation States

**User Story:** As a player, I want the chicken to have different animations for different situations, so that the game feels lively and provides visual feedback for my actions.

#### Acceptance Criteria

1. THE Game System SHALL display an idle animation WHEN the Character is floating without input
2. THE Game System SHALL display a fart animation WHEN the Player performs a Fart Action
3. THE Game System SHALL display a falling animation WHEN the Character is descending rapidly
4. WHEN collision is detected, THE Game System SHALL play the Character falling to the ground
5. WHEN the Character reaches the ground after collision, THE Game System SHALL display a tombstone animation rising from the ground at the Character position
6. THE Game System SHALL display the current Score on the tombstone inscription
7. THE Game System SHALL include a visual fart particle effect using SpriteKit particle system during the fart animation

### Requirement 8: Visual Presentation

**User Story:** As a player, I want clear pixel art graphics and smooth animations, so that the game is visually appealing and easy to understand.

#### Acceptance Criteria

1. THE Game System SHALL render all sprites using pixel art style graphics
2. THE Game System SHALL display a scrolling background during gameplay
3. THE Game System SHALL display a scrolling ground texture at the bottom of the screen
4. THE Game System SHALL maintain consistent visual style across all game elements
5. THE Game System SHALL display smooth transitions between Character animation states

### Requirement 9: Game State Management

**User Story:** As a player, I want clear game states with appropriate screens, so that I know when to start playing and when the game has ended.

#### Acceptance Criteria

1. WHEN the Game System launches, THE Game System SHALL display a start screen with play button
2. WHEN the Player taps the play button, THE Game System SHALL transition to active gameplay state
3. WHEN game over is triggered, THE Game System SHALL transition to game over state
4. WHEN in game over state and the Player taps the screen, THE Game System SHALL restart the Game Session
5. THE Game System SHALL reset Score to zero when starting a new Game Session

### Requirement 10: Multi-Device Support

**User Story:** As a player, I want the game to work on both iPhone and iPad, so that I can play on whichever device I prefer.

#### Acceptance Criteria

1. THE Game System SHALL support iPhone devices running iOS 15 or later
2. THE Game System SHALL support iPad devices running iOS 15 or later
3. THE Game System SHALL scale the game view appropriately for different screen sizes
4. THE Game System SHALL maintain consistent gameplay mechanics across all supported devices
5. THE Game System SHALL maintain aspect ratio to prevent sprite distortion

### Requirement 11: Modular Asset System

**User Story:** As a developer, I want a modular asset system that allows easy theme changes, so that I can create variations like Farty Spaceman or Farty Eagle without code changes.

#### Acceptance Criteria

1. THE Game System SHALL load all sprite assets from a designated Asset Pack directory
2. THE Game System SHALL use consistent naming conventions for asset files across different Asset Packs
3. WHEN an Asset Pack is changed, THE Game System SHALL load sprites from the new Asset Pack location
4. THE Game System SHALL define asset file names in a configuration file
5. THE Game System SHALL continue functioning with placeholder graphics when asset files are missing

### Requirement 12: Audio System

**User Story:** As a player, I want sound effects for game actions, so that the game provides audio feedback and enhanced entertainment.

#### Acceptance Criteria

1. WHEN the Character performs a Fart Action, THE Game System SHALL play a fart sound effect
2. WHEN the Character collides with an Obstacle, THE Game System SHALL play a collision sound effect
3. WHEN the Score increments, THE Game System SHALL play a scoring sound effect
4. THE Game System SHALL provide a settings option to mute all sound effects
5. THE Game System SHALL persist the sound mute setting between Game Sessions

### Requirement 13: Performance Requirements

**User Story:** As a player, I want smooth gameplay without lag or stuttering, so that I can enjoy a responsive gaming experience.

#### Acceptance Criteria

1. THE Game System SHALL maintain 60 frames per second during active gameplay
2. THE Game System SHALL complete app launch within 2 seconds on supported devices
3. THE Game System SHALL respond to tap input within 16 milliseconds
4. THE Game System SHALL use less than 100 megabytes of device memory during gameplay
5. THE Game System SHALL use SpriteKit for hardware-accelerated rendering
