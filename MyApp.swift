import SwiftUI
import SwiftData

@main
struct MyApp: App {
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            
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
                .sheet(isPresented: $showWelcomeView) {
                    WelcomeView(showWelcomeView: $showWelcomeView)
                }
                .onAppear {
                    UserDefaults.standard.removeObject(forKey: "showWelcomeView")
                }
            }
        }
        .modelContainer(RoutesContainer.create())
    }
}
