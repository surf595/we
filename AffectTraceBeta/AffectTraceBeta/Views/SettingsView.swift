import SwiftUI

struct SettingsView: View {
    @State private var appLockEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Безопасность") {
                    Toggle("Защита приложения (Face ID)", isOn: $appLockEnabled)
                }

                Section("Данные") {
                    Button("Экспорт TXT/JSON") {}
                    Button("Удалить все локальные данные", role: .destructive) {}
                }

                Section("Подписка") {
                    Button("Восстановить покупки") {}
                }

                Section("Помощь") {
                    Text("Приложение не предназначено для экстренной психологической помощи.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Настройки")
        }
    }
}
