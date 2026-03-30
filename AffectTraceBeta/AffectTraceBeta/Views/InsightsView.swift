import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            List(store.weeklyPatterns()) { pattern in
                VStack(alignment: .leading, spacing: 8) {
                    Text(pattern.title)
                        .font(.headline)
                    Text(pattern.details)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
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
