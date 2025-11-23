import Foundation

struct AssetConfiguration: Codable {
    var currentTheme: String
    var themes: [String: ThemeInfo]
    var assetNames: [String: String]
    
    struct ThemeInfo: Codable {
        var path: String
        var displayName: String
    }
    
    static var `default`: AssetConfiguration {
        return AssetConfiguration(
            currentTheme: "chicken",
            themes: [
                "chicken": ThemeInfo(
                    path: "Themes/chicken",
                    displayName: "Farty Chicken"
                )
            ],
            assetNames: [
                "characterIdle": "character_idle",
                "characterFart": "character_fart",
                "characterFalling": "character_falling",
                "pipeTop": "pipe_top",
                "pipeBottom": "pipe_bottom",
                "backgroundSky": "background_sky",
                "ground": "ground",
                "tombstone": "tombstone"
            ]
        )
    }
}
