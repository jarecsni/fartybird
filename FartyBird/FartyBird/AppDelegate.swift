import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create and set root view controller
        let gameViewController = GameViewController()
        window?.rootViewController = gameViewController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Pause game when app enters background
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Resume game when app becomes active
    }
}
