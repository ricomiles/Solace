import Foundation
import SwiftData

@Model
final class AppSettings {
    var faceIDEnabled: Bool
    var hasCompletedOnboarding: Bool
    var moodTrackingEnabled: Bool
    var createdAt: Date

    init() {
        faceIDEnabled = false
        hasCompletedOnboarding = false
        moodTrackingEnabled = true
        createdAt = .now
    }
}
