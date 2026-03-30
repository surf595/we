import Foundation

final class AppStore: ObservableObject {
    @Published private(set) var checkIns: [CheckInEntry] = []
    @Published private(set) var events: [EventLogEntry] = []

    private let fileURL: URL

    init() {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: "/tmp")
        fileURL = base.appendingPathComponent("affect_trace_beta.json")
        load()
    }

    func addCheckIn(values: [CheckInMetric: Int], note: String) {
        let entry = CheckInEntry(id: UUID(), createdAt: Date(), note: note, values: values)
        checkIns.insert(entry, at: 0)
        save()
    }

    func addEvent(_ event: EventLogEntry) {
        events.insert(event, at: 0)
        save()
    }

    func weeklyPatterns() -> [WeeklyPattern] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentEvents = events.filter { $0.createdAt >= weekAgo }

        guard !recentEvents.isEmpty else {
            return [WeeklyPattern(title: "Недостаточно данных", details: "Добавьте минимум 2–3 события за неделю для устойчивых наблюдений.")]
        }

        let topResponse = Dictionary(grouping: recentEvents.flatMap(\.responses), by: { $0 })
            .max { $0.value.count < $1.value.count }?.key

        let unresolvedCount = recentEvents.filter(\.unresolved).count
        var result: [WeeklyPattern] = []

        if let response = topResponse {
            result.append(.init(
                title: "Повторяющаяся реакция",
                details: "На этой неделе чаще всего отмечалась реакция: \(response.rawValue.lowercased())."
            ))
        }

        if unresolvedCount > 0 {
            result.append(.init(
                title: "Незавершённые эпизоды",
                details: "Незавершённых контактов: \(unresolvedCount). Можно вынести их в подготовку к сессии."
            ))
        }

        let misunderstoodPeak = checkIns
            .filter { $0.createdAt >= weekAgo }
            .map { $0.values[.misunderstood] ?? 0 }
            .max() ?? 0

        if misunderstoodPeak >= 3 {
            result.append(.init(
                title: "Ощущение непонятости",
                details: "В отдельные моменты ощущение непонятости поднималось до высокого уровня."
            ))
        }

        return result.isEmpty
            ? [WeeklyPattern(title: "Нейтральная неделя", details: "Явные паттерны не выделились. Продолжайте наблюдение.")]
            : result
    }

    func sessionPrepItems() -> [String] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let unresolved = events.filter { $0.createdAt >= weekAgo && $0.unresolved }

        var items = weeklyPatterns().map { "• \($0.title): \($0.details)" }
        if !unresolved.isEmpty {
            items.append("• Невысказанное: проверьте поля «что хотел(а), но не сказал(а)» в незавершённых событиях.")
        }
        return Array(items.prefix(5))
    }

    private struct Snapshot: Codable {
        var checkIns: [CheckInEntry]
        var events: [EventLogEntry]
    }

    private func save() {
        let snapshot = Snapshot(checkIns: checkIns, events: events)
        if let data = try? JSONEncoder().encode(snapshot) {
            try? data.write(to: fileURL, options: [.atomic])
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) else {
            return
        }
        checkIns = snapshot.checkIns
        events = snapshot.events
    }
}
