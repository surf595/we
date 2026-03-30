import SwiftUI

struct EventLogView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var happened = ""
    @State private var withWhom = ""
    @State private var firstFeeling = ""
    @State private var actionTaken = ""
    @State private var unsaidNeed = ""
    @State private var contactEnd = ""
    @State private var unresolved = false
    @State private var selectedResponses = Set<ProtectiveResponse>()

    var body: some View {
        NavigationStack {
            Form {
                Section("Эпизод") {
                    TextField("Что произошло", text: $happened, axis: .vertical)
                    TextField("С кем", text: $withWhom)
                    TextField("Что почувствовал(а) сначала", text: $firstFeeling, axis: .vertical)
                    TextField("Что сделал(а)", text: $actionTaken, axis: .vertical)
                    TextField("Что хотел(а), но не сказал(а)", text: $unsaidNeed, axis: .vertical)
                    TextField("Как закончился контакт", text: $contactEnd, axis: .vertical)
                    Toggle("Эпизод незавершён", isOn: $unresolved)
                }

                Section("Типичные реакции") {
                    ForEach(ProtectiveResponse.allCases) { response in
                        MultipleSelectionRow(
                            title: response.rawValue,
                            isSelected: selectedResponses.contains(response)
                        ) {
                            if selectedResponses.contains(response) {
                                selectedResponses.remove(response)
                            } else if selectedResponses.count < 5 {
                                selectedResponses.insert(response)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Событие / контакт")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        let entry = EventLogEntry(
                            id: UUID(),
                            createdAt: Date(),
                            happened: happened,
                            withWhom: withWhom,
                            firstFeeling: firstFeeling,
                            actionTaken: actionTaken,
                            unsaidNeed: unsaidNeed,
                            contactEnd: contactEnd,
                            responses: Array(selectedResponses),
                            unresolved: unresolved
                        )
                        store.addEvent(entry)
                        dismiss()
                    }
                    .disabled(happened.isEmpty || contactEnd.isEmpty)
                }
            }
        }
    }
}

private struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .foregroundStyle(.primary)
    }
}
