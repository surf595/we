import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Сегодня", systemImage: "house") }

            LogListView()
                .tabItem { Label("Лог", systemImage: "list.bullet.rectangle") }

            InsightsView()
                .tabItem { Label("Итоги", systemImage: "chart.line.uptrend.xyaxis") }

            SessionPrepView()
                .tabItem { Label("Сессия", systemImage: "doc.text") }

            SettingsView()
                .tabItem { Label("Настройки", systemImage: "gearshape") }
        }
    }
}
