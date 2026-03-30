import SwiftUI

@main
struct WeApp: App {
    @StateObject private var store = BetaStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
