import SwiftUI

enum MoodType: String, CaseIterable, Codable, Identifiable {
    case calm     = "calm"
    case tender   = "tender"
    case warm     = "warm"
    case hopeful  = "hopeful"
    case restless = "restless"
    case heavy    = "heavy"

    var id: String { rawValue }

    var displayName: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }

    var backgroundColor: Color {
        switch self {
        case .calm:     return .moodCalmBg
        case .tender:   return .moodTenderBg
        case .warm:     return .moodWarmBg
        case .hopeful:  return .moodHopefulBg
        case .restless: return .moodRestlessBg
        case .heavy:    return .moodHeavyBg
        }
    }

    var dotColor: Color {
        switch self {
        case .calm:     return .moodCalmDot
        case .tender:   return .moodTenderDot
        case .warm:     return .moodWarmDot
        case .hopeful:  return .moodHopefulDot
        case .restless: return .moodRestlessDot
        case .heavy:    return .moodHeavyDot
        }
    }
}
