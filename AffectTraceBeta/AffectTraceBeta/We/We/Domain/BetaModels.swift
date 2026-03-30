import Foundation

enum AffectScale: String, CaseIterable, Codable, Identifiable {
    case tension = "Напряжение"
    case anger = "Злость"
    case emptiness = "Пустота"
    case shame = "Стыд"
    case selfBlame = "Самообвинение"
    case withdrawUrge = "Желание отдалиться"
    case needForContact = "Потребность в контакте"
    case misunderstood = "Ощущение непонятости"

    var id: String { rawValue }
}

enum ProtectiveReaction: String, CaseIterable, Codable, Identifiable {
    case wentSilent = "Замолчал"
    case withdrew = "Отдалился"
    case snapped = "Сорвался"
    case devalued = "Обесценил"
    case controlled = "Начал контролировать"
    case tooNice = "Стал «слишком хорошим»"
    case fantasyEscape = "Ушел в фантазии"
    case selfAccusation = "Обвинил себя"
    case numbedOut = "Сделал вид, что ничего не чувствую"

    var id: String { rawValue }
}

struct DailyCheckIn: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    var values: [AffectScale: Int]
    var note: String
}

struct ContactEvent: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    var happened: String
    var person: String
    var firstFeeling: String
    var action: String
    var unsaid: String
    var ending: String
    var unresolved: Bool
    var reactions: [ProtectiveReaction]
}

struct SummaryCard: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}
