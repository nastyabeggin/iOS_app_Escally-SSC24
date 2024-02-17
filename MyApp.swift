import SwiftUI
import SwiftData
import TipKit

@main
struct MyApp: App {
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true

    var body: some Scene {
        WindowGroup {
            if showWelcomeView {
                WelcomeView(showWelcomeView: $showWelcomeView)
            } else {
                TabView {
                    Group {
                        ClimbingRoutesListView()
                            .tabItem {
                                Label("Routes", systemImage: "figure.climbing")
                            }
                        RoutesJournalView()
                            .tabItem {
                                Label("Journal", systemImage: "chart.bar.fill")
                            }
                        ChartsView()
                            .tabItem {
                                Label("Charts", systemImage: "chart.pie.fill")
                            }
                    }
//                    .onAppear {
//                        try? Tips.resetDatastore()
//                        UserDefaults.standard.removeObject(forKey: "showWelcomeView")
//                    }
                }
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
            }
        }
        .modelContainer(RoutesContainer.create())
    }
}
