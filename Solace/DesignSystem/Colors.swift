import SwiftUI

extension Color {
    // MARK: - Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }

    // MARK: - Background
    static let solaceBgCream   = Color(hex: "F4ECE0")
    static let solaceBgPaper   = Color(hex: "FAF5EC")
    static let solaceBgWarm    = Color(hex: "EDE2D2")
    static let solaceBgDeep    = Color(hex: "E5D7C2")

    // MARK: - Terracotta
    static let solaceTerra50   = Color(hex: "F7E8DC")
    static let solaceTerra100  = Color(hex: "EDD3BD")
    static let solaceTerra200  = Color(hex: "D4A88C")
    static let solaceTerra300  = Color(hex: "B8896C")
    static let solaceTerra400  = Color(hex: "8B7355")

    // MARK: - Sage
    static let solaceSage100   = Color(hex: "DCDDC7")
    static let solaceSage200   = Color(hex: "B8BBA0")

    // MARK: - Ink
    static let solaceInk900    = Color(hex: "3A332B")
    static let solaceInk700    = Color(hex: "5C5247")
    static let solaceInk500    = Color(hex: "7C7062")
    static let solaceInk300    = Color(hex: "A89A88")
    static let solaceInk200    = Color(hex: "C9BCA8")

    // MARK: - Separators
    static let solaceHairline       = Color(red: 0.227, green: 0.200, blue: 0.169, opacity: 0.08)
    static let solaceHairlineStrong = Color(red: 0.227, green: 0.200, blue: 0.169, opacity: 0.14)

    // MARK: - Mood backgrounds
    static let moodCalmBg     = Color(hex: "DCDDC7")
    static let moodTenderBg   = Color(hex: "E8C4B0")
    static let moodWarmBg     = Color(hex: "EDD3BD")
    static let moodHopefulBg  = Color(hex: "E5D2A8")
    static let moodRestlessBg = Color(hex: "D9B895")
    static let moodHeavyBg   = Color(hex: "C9B8A8")

    // MARK: - Mood dots
    static let moodCalmDot     = Color(hex: "9CA888")
    static let moodTenderDot   = Color(hex: "D8A892")
    static let moodWarmDot     = Color(hex: "B8896C")
    static let moodHopefulDot  = Color(hex: "C9B080")
    static let moodRestlessDot = Color(hex: "B89678")
    static let moodHeavyDot   = Color(hex: "8B7E6E")
}
