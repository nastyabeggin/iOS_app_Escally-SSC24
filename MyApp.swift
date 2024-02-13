import SwiftUI
import SwiftData

@main
struct MyApp: App {
    @State var showWelcome = false

    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView(showWelcomeView: $showWelcome)
            } else {
                TabView {
                    Group {
                        ClimbingRoutesListView()
                            .tabItem {
                                Label("Routes", systemImage: "mountain.2")
                            }
                        RoutesJournalView()
                            .tabItem {
                                Label("Journal",
                                      systemImage: "chart.bar.fill")
                            }
                        ChartsView()
                            .tabItem {
                                Label("Charts",
                                      systemImage: "chart.pie.fill")
                            }
                    }
                }
            }
        }
        .modelContainer(for: ClimbingRoute.self)
    }
}
