import SwiftUI

struct SessionPrepView: View {
    @EnvironmentObject private var store: AppStore
    @State private var hardToSay = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("3–5 ключевых паттернов") {
                    ForEach(store.sessionPrepItems(), id: \.self) { item in
                        Text(item)
                    }
                }

                Section("Что мне трудно сказать") {
                    TextField("Свободная заметка", text: $hardToSay, axis: .vertical)
                        .lineLimit(6)
                }
            }
            .navigationTitle("Что взять в терапию")
        }
    }
}
