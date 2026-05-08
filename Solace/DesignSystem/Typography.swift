import SwiftUI

// Variable font family names — must match what the OS registers from UIAppFonts.
private let newsreaderRoman    = "Newsreader"
private let newsreaderItalic   = "Newsreader-Italic"
private let mulishFontName     = "Mulish"

extension Font {
    // MARK: - Newsreader (serif)
    static func newsreader(_ size: CGFloat, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        let name = italic ? newsreaderItalic : newsreaderRoman
        return .custom(name, size: size).weight(weight)
    }

    // MARK: - Mulish (sans)
    static func mulish(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom(mulishFontName, size: size).weight(weight)
    }

    // MARK: - Named type scale
    static let newsreaderDisplay    = Font.newsreader(48)
    static let newsreaderH1Large    = Font.newsreader(44)
    static let newsreaderH1         = Font.newsreader(38)
    static let newsreaderH1Entry    = Font.newsreader(32)
    static let newsreaderH2         = Font.newsreader(22, weight: .medium)
    static let newsreaderH2Body     = Font.newsreader(22)
    static let newsreaderBody       = Font.newsreader(18)
    static let newsreaderBodyItalic = Font.newsreader(17, italic: true)
    static let newsreaderPrompt     = Font.newsreader(26)
    static let newsreaderSubhead    = Font.newsreader(17, italic: true)

    static let mulishLabel          = Font.mulish(15, weight: .medium)
    static let mulishLabelSemibold  = Font.mulish(15, weight: .semibold)
    static let mulishCaption        = Font.mulish(13, weight: .medium)
    static let mulishSmall          = Font.mulish(12, weight: .medium)
    static let mulishEyebrow        = Font.mulish(11, weight: .bold)
    static let mulishMicro          = Font.mulish(10, weight: .bold)
}
