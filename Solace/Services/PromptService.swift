import Foundation

struct Prompt: Codable, Identifiable {
    let text: String
    let author: String?
    let theme: String?

    var id: String { text }
}

struct PromptService {
    static let shared = PromptService()
    private let prompts: [Prompt]

    private init() {
        guard let url = Bundle.main.url(forResource: "prompts", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Prompt].self, from: data)
        else {
            fatalError("prompts.json is missing or malformed — this is a required bundled resource")
        }
        prompts = decoded
    }

    func todayPrompt(for date: Date = .now) -> Prompt {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        return prompts[(dayOfYear - 1) % prompts.count]
    }

    func allPrompts() -> [Prompt] { prompts }
}
