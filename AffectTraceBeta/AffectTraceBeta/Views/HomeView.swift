import SwiftUI

struct HomeView: View {
    @State private var showCheckIn = false
    @State private var showEvent = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Наблюдение без оценок")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Button("Быстрый check-in") { showCheckIn = true }
                    .buttonStyle(.borderedProminent)

                Button("Записать событие") { showEvent = true }
                    .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .navigationTitle("Сегодня")
            .sheet(isPresented: $showCheckIn) { CheckInView() }
            .sheet(isPresented: $showEvent) { EventLogView() }
        }
    }
}
