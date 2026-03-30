import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem { Label("Сегодня", systemImage: "house") }
            LogScreen()
                .tabItem { Label("Лог", systemImage: "list.bullet") }
            InsightsScreen()
                .tabItem { Label("Итоги", systemImage: "chart.line.uptrend.xyaxis") }
            SessionScreen()
                .tabItem { Label("Сессия", systemImage: "doc.text") }
            SettingsScreen()
                .tabItem { Label("Настройки", systemImage: "gear") }
        }
    }
}

private struct HomeScreen: View {
    @State private var openCheckIn = false
    @State private var openEvent = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Text("Наблюдение без оценок")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Button("Быстрый check-in") { openCheckIn = true }
                    .buttonStyle(.borderedProminent)
                Button("Событие / контакт") { openEvent = true }
                    .buttonStyle(.bordered)
                Spacer()
            }
            .padding()
            .navigationTitle("Сегодня")
            .sheet(isPresented: $openCheckIn) { CheckInScreen() }
            .sheet(isPresented: $openEvent) { EventScreen() }
        }
    }
}

private struct CheckInScreen: View {
    @EnvironmentObject private var store: BetaStore
    @Environment(\.dismiss) private var dismiss
    @State private var values = Dictionary(uniqueKeysWithValues: AffectScale.allCases.map { ($0, 0) })
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("20–40 секунд") {
                    ForEach(AffectScale.allCases) { scale in
                        Stepper("\(scale.rawValue): \(values[scale] ?? 0)", value: binding(for: scale), in: 0...4)
                    }
                }
                Section("Короткая заметка") {
                    TextField("До 180 символов", text: $note, axis: .vertical)
                        .lineLimit(3)
                }
            }
            .navigationTitle("Как вы сейчас?")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Отмена") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        store.saveCheckIn(values: values, note: note)
                        dismiss()
                    }
                    .disabled(values.values.allSatisfy { $0 == 0 })
                }
            }
        }
    }

    private func binding(for scale: AffectScale) -> Binding<Int> {
        Binding(get: { values[scale] ?? 0 }, set: { values[scale] = $0 })
    }
}

private struct EventScreen: View {
    @EnvironmentObject private var store: BetaStore
    @Environment(\.dismiss) private var dismiss
    @State private var happened = ""
    @State private var person = ""
    @State private var firstFeeling = ""
    @State private var action = ""
    @State private var unsaid = ""
    @State private var ending = ""
    @State private var unresolved = false
    @State private var reactions = Set<ProtectiveReaction>()

    var body: some View {
        NavigationStack {
            Form {
                Section("Эпизод") {
                    TextField("Что произошло", text: $happened, axis: .vertical)
                    TextField("С кем", text: $person)
                    TextField("Что почувствовал(а) сначала", text: $firstFeeling)
                    TextField("Что сделал(а)", text: $action)
                    TextField("Что хотел(а), но не сказал(а)", text: $unsaid)
                    TextField("Как закончился контакт", text: $ending)
                    Toggle("Незавершённый эпизод", isOn: $unresolved)
                }
                Section("Реакции (до 5)") {
                    ForEach(ProtectiveReaction.allCases) { reaction in
                        Button {
                            if reactions.contains(reaction) {
                                reactions.remove(reaction)
                            } else if reactions.count < 5 {
                                reactions.insert(reaction)
                            }
                        } label: {
                            HStack {
                                Text(reaction.rawValue)
                                Spacer()
                                if reactions.contains(reaction) { Image(systemName: "checkmark") }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("Событие / контакт")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Отмена") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        store.saveEvent(ContactEvent(
                            id: UUID(),
                            createdAt: Date(),
                            happened: happened,
                            person: person,
                            firstFeeling: firstFeeling,
                            action: action,
                            unsaid: unsaid,
                            ending: ending,
                            unresolved: unresolved,
                            reactions: Array(reactions)
                        ))
                        dismiss()
                    }
                    .disabled(happened.isEmpty || ending.isEmpty)
                }
            }
        }
    }
}

private struct LogScreen: View {
    @EnvironmentObject private var store: BetaStore

    var body: some View {
        NavigationStack {
            List {
                if store.events.isEmpty {
                    Text("Пока нет записей. Начните с check-in за 30 секунд.")
                        .foregroundStyle(.secondary)
                }
                ForEach(store.events) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.happened).font(.headline)
                        Text(event.ending).foregroundStyle(.secondary)
                        Text(event.createdAt, style: .date).font(.caption)
                    }
                }
            }
            .navigationTitle("Лог")
        }
    }
}

private struct InsightsScreen: View {
    @EnvironmentObject private var store: BetaStore

    var body: some View {
        NavigationStack {
            List(store.weeklyCards()) { card in
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.title).font(.headline)
                    Text(card.subtitle).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Итоги недели")
            .safeAreaInset(edge: .bottom) {
                Text("Наблюдательная сводка, не клиническая интерпретация")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
        }
    }
}

private struct SessionScreen: View {
    @EnvironmentObject private var store: BetaStore

    var body: some View {
        NavigationStack {
            Form {
                Section("Ключевые паттерны") {
                    ForEach(store.weeklyCards()) { card in
                        Text("• \(card.title): \(card.subtitle)")
                    }
                }
                Section("Что мне трудно сказать") {
                    TextField("Свободная заметка", text: $store.hardToSay, axis: .vertical)
                        .lineLimit(6)
                        .onChange(of: store.hardToSay) { _, _ in store.persistSessionNote() }
                }
            }
            .navigationTitle("Что взять в терапию")
        }
    }
}

private struct SettingsScreen: View {
    @State private var appLock = true
    @State private var proEnabled = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Приватность") {
                    Toggle("Face ID / код-пароль", isOn: $appLock)
                    Button("Экспорт TXT/JSON") {}
                }
                Section("Freemium") {
                    Toggle("Pro (beta-переключатель)", isOn: $proEnabled)
                    Text("В beta подписки не подключены.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section("Безопасность") {
                    Text("Приложение не предназначено для экстренной психологической помощи.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Настройки")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BetaStore())
}
