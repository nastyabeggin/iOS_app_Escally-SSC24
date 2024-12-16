import SwiftUI
import SwiftData
import TipKit

@main
struct MyApp: App {
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            Group {
                if showWelcomeView {
                    WelcomeView(showWelcomeView: $showWelcomeView)
                        .transition(.opacity)
                        .onDisappear {
                            configureTips()
                        }
                } else if isLoading {
                    ProgressView("Loading...")
                }
                else {
                    mainTabView
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showWelcomeView)
        }
        .task {
            await initializeRoutesContainer()
        }
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
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }

    private func initializeRoutesContainer() async {
        do {
            let container = try await RoutesContainer()
            DispatchQueue.main.async {
                self.routesContainer = container
                self.isLoading = false
            }
        } catch {
            Logger.error("Failed to initialize RoutesContainer: \(error.localizedDescription)")
        }
    }
}
