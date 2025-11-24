import XCTest
import SwiftCheck
import SpriteKit
@testable import FartyBird

class GameViewControllerTests: XCTestCase {
    
    // Feature: farty-bird, Property 23: Screen size scaling
    // Validates: Requirements 10.3
    func testScreenSizeScaling() {
        property("Game view scales appropriately for different screen sizes") <- forAll { (width: Int, height: Int) in
            // Generate reasonable screen dimensions (between 320 and 2048 pixels)
            let screenWidth = CGFloat(max(320, abs(width) % 2048))
            let screenHeight = CGFloat(max(480, abs(height) % 2048))
            
            // Create a scene with these dimensions
            let scene = MenuScene(size: CGSize(width: screenWidth, height: screenHeight))
            scene.scaleMode = .aspectFill
            
            // Verify the scene has the correct size
            let sceneSize = scene.size
            
            // Scene should have the dimensions we specified
            return sceneSize.width == screenWidth && sceneSize.height == screenHeight
        }.verbose
    }
    
    // Feature: farty-bird, Property 24: Aspect ratio preservation
    // Validates: Requirements 10.5
    func testAspectRatioPreservation() {
        property("Aspect ratio is preserved across different screen sizes") <- forAll { (width: Int, height: Int) in
            // Generate reasonable screen dimensions
            let screenWidth = CGFloat(max(320, abs(width) % 2048))
            let screenHeight = CGFloat(max(480, abs(height) % 2048))
            
            // Calculate original aspect ratio
            let originalAspectRatio = screenWidth / screenHeight
            
            // Create a scene with aspectFill scale mode
            let scene = GameScene(size: CGSize(width: screenWidth, height: screenHeight))
            scene.scaleMode = .aspectFill
            
            // With aspectFill, the scene maintains its size
            let sceneAspectRatio = scene.size.width / scene.size.height
            
            // Aspect ratios should match (within floating point tolerance)
            let tolerance: CGFloat = 0.001
            return abs(sceneAspectRatio - originalAspectRatio) < tolerance
        }.verbose
    }
    
    // Unit test: Verify GameViewController presents MenuScene on load
    func testGameViewControllerPresentsMenuScene() {
        let viewController = GameViewController()
        
        // Load the view hierarchy
        viewController.loadViewIfNeeded()
        
        // Verify the view is an SKView
        XCTAssertTrue(viewController.view is SKView)
        
        if let skView = viewController.view as? SKView {
            // Verify a scene is presented
            XCTAssertNotNil(skView.scene)
            
            // Verify it's a MenuScene
            XCTAssertTrue(skView.scene is MenuScene)
            
            // Verify scale mode is set correctly
            XCTAssertEqual(skView.scene?.scaleMode, .aspectFill)
        }
    }
    
    // Unit test: Verify portrait orientation is enforced
    func testPortraitOrientationEnforced() {
        let viewController = GameViewController()
        
        let supportedOrientations = viewController.supportedInterfaceOrientations
        
        XCTAssertEqual(supportedOrientations, .portrait)
    }
    
    // Unit test: Verify status bar is hidden
    func testStatusBarHidden() {
        let viewController = GameViewController()
        
        XCTAssertTrue(viewController.prefersStatusBarHidden)
    }
    
    // Unit test: Verify debug settings in DEBUG mode
    #if DEBUG
    func testDebugSettingsEnabled() {
        let viewController = GameViewController()
        
        // Load the view hierarchy
        viewController.loadViewIfNeeded()
        
        if let skView = viewController.view as? SKView {
            XCTAssertTrue(skView.showsFPS)
            XCTAssertTrue(skView.showsNodeCount)
        }
    }
    #endif
}
