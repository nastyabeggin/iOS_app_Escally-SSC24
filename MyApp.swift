import SwiftUI
import SwiftData
import TipKit

@main
struct MyApp: App {
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showWelcomeView {
                    WelcomeView(showWelcomeView: $showWelcomeView)
                        .transition(.opacity)
                        .onDisappear {
                            configureTips()
                        }
                } else {
                    mainTabView
                        .task {
                            // TODO: REMOVE
                            UserDefaults.standard.removeObject(forKey: "showWelcomeView")
                        }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showWelcomeView)
        }
        .modelContainer(RoutesContainer.create())
    }
    
    var mainTabView: some View {
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
        }
    }
    
    func configureTips() {
        // TODO: REMOVE
        try? Tips.resetDatastore()
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }
}
