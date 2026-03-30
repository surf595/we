import Foundation

enum CheckInMetric: String, CaseIterable, Identifiable, Codable {
    case tension = "Напряжение"
    case anger = "Злость"
    case emptiness = "Пустота"
    case shame = "Стыд"
    case selfBlame = "Самообвинение"
    case withdrawUrge = "Желание отдалиться"
    case contactNeed = "Потребность в контакте"
    case misunderstood = "Ощущение непонятости"

    var id: String { rawValue }
}

enum ProtectiveResponse: String, CaseIterable, Identifiable, Codable {
    case silent = "Замолчал"
    case withdrew = "Отдалился"
    case snapped = "Сорвался"
    case devalued = "Обесценил"
    case controlled = "Начал контролировать"
    case tooNice = "Стал слишком хорошим"
    case fantasy = "Ушел в фантазии"
    case selfBlamed = "Обвинил себя"
    case numbed = "Сделал вид, что ничего не чувствую"

    var id: String { rawValue }
}

struct CheckInEntry: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    var note: String
    var values: [CheckInMetric: Int]
}

struct EventLogEntry: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    var happened: String
    var withWhom: String
    var firstFeeling: String
    var actionTaken: String
    var unsaidNeed: String
    var contactEnd: String
    var responses: [ProtectiveResponse]
    var unresolved: Bool
}

struct WeeklyPattern: Identifiable {
    let id = UUID()
    let title: String
    let details: String
}
