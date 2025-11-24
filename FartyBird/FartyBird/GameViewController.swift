import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        // Create an SKView programmatically
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        if let view = self.view as? SKView {
            // Set up SKView properties
            view.ignoresSiblingOrder = true
            
            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            #endif
            
            // Present the menu scene
            presentMenuScene(in: view)
        }
    }
    
    // MARK: - Scene Presentation
    
    /// Presents the MenuScene with appropriate scaling for multi-device support
    private func presentMenuScene(in view: SKView) {
        // Create the menu scene with the view's bounds
        let scene = MenuScene(size: view.bounds.size)
        
        // Configure scene scale mode for multi-device support
        // AspectFill ensures the scene fills the entire screen while maintaining aspect ratio
        scene.scaleMode = .aspectFill
        
        // Present the scene
        view.presentScene(scene)
    }

    // MARK: - Interface Orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - iOS Lifecycle Events
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the scene when view is about to disappear
        if let view = self.view as? SKView {
            view.isPaused = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Resume the scene when view appears
        if let view = self.view as? SKView {
            view.isPaused = false
        }
    }
}
