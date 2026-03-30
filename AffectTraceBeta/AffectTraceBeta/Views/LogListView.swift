import SwiftUI

struct LogListView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            List {
                if store.events.isEmpty {
                    Text("Пока нет эпизодов. Добавьте первый контакт из Home.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.events) { event in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(event.happened)
                                .font(.headline)
                            Text(event.contactEnd)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(event.createdAt, style: .date)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            .navigationTitle("Лог")
        }
    }
}
