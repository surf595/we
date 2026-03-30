import SwiftUI

struct CheckInView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var values: [CheckInMetric: Int] = Dictionary(uniqueKeysWithValues: CheckInMetric.allCases.map { ($0, 0) })
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Это займет ~30 секунд") {
                    ForEach(CheckInMetric.allCases) { metric in
                        Stepper("\(metric.rawValue): \(values[metric] ?? 0)", value: binding(for: metric), in: 0...4)
                    }
                }

                Section("Короткая заметка (опционально)") {
                    TextField("До 180 символов", text: $note, axis: .vertical)
                        .lineLimit(3)
                }
            }
            .navigationTitle("Как вы сейчас?")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        store.addCheckIn(values: values, note: String(note.prefix(180)))
                        dismiss()
                    }
                    .disabled(values.values.allSatisfy { $0 == 0 })
                }
            }
        }
    }

    private func binding(for metric: CheckInMetric) -> Binding<Int> {
        Binding(
            get: { values[metric] ?? 0 },
            set: { values[metric] = $0 }
        )
    }
}
