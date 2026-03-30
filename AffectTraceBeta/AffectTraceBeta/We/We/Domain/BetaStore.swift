import Foundation

final class BetaStore: ObservableObject {
    @Published private(set) var checkIns: [DailyCheckIn] = []
    @Published private(set) var events: [ContactEvent] = []
    @Published var hardToSay = ""

    private let storageURL: URL

    init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: "/tmp")
        storageURL = docs.appendingPathComponent("we_beta_storage.json")
        load()
    }

    func saveCheckIn(values: [AffectScale: Int], note: String) {
        let record = DailyCheckIn(id: UUID(), createdAt: Date(), values: values, note: String(note.prefix(180)))
        checkIns.insert(record, at: 0)
        persist()
    }

    func saveEvent(_ event: ContactEvent) {
        events.insert(event, at: 0)
        persist()
    }

    func weeklyCards() -> [SummaryCard] {
        let weekStart = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentEvents = events.filter { $0.createdAt >= weekStart }
        let recentCheckIns = checkIns.filter { $0.createdAt >= weekStart }

        guard !recentEvents.isEmpty || !recentCheckIns.isEmpty else {
            return [.init(title: "Недостаточно данных", subtitle: "Сделайте минимум 3 check-in или 2 события за неделю.")]
        }

        var output: [SummaryCard] = []
        if let topReaction = Dictionary(grouping: recentEvents.flatMap(\.reactions), by: { $0 })
            .max(by: { $0.value.count < $1.value.count })?.key {
            output.append(.init(title: "Частая реакция", subtitle: "Чаще всего отмечалось: \(topReaction.rawValue.lowercased())."))
        }

        let unresolved = recentEvents.filter(\.unresolved).count
        if unresolved > 0 {
            output.append(.init(title: "Незавершённые эпизоды", subtitle: "На этой неделе их: \(unresolved)."))
        }

        let misunderstood = recentCheckIns.map { $0.values[.misunderstood] ?? 0 }.max() ?? 0
        if misunderstood >= 3 {
            output.append(.init(title: "Ощущение непонятости", subtitle: "В отдельные моменты поднималось до высокого уровня."))
        }

        return output.isEmpty ? [.init(title: "Нейтральная динамика", subtitle: "Явные повторяющиеся связки пока не выделились.")] : output
    }

    private struct Snapshot: Codable {
        var checkIns: [DailyCheckIn]
        var events: [ContactEvent]
        var hardToSay: String
    }

    private func persist() {
        let snapshot = Snapshot(checkIns: checkIns, events: events, hardToSay: hardToSay)
        if let data = try? JSONEncoder().encode(snapshot) {
            try? data.write(to: storageURL, options: .atomic)
        }
    }

    func persistSessionNote() {
        persist()
    }

    private func load() {
        guard let data = try? Data(contentsOf: storageURL), let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) else {
            return
        }
        checkIns = snapshot.checkIns
        events = snapshot.events
        hardToSay = snapshot.hardToSay
    }
}
