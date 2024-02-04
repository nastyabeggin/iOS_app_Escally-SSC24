import SwiftUI

@main
struct MyApp: App {
    @State var showWelcome = false
    @StateObject var climbingRoutesData = ClimbingRoutesData()

    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView(showWelcomeView: $showWelcome)
            } else {
                TabView {
                    Group {
                        ClimbingRoutesListView(climbingRoutesData: climbingRoutesData)
                            .tabItem {
                                Label("Routes", systemImage: "mountain.2")
                            }
                        ChartsView(climbingRoutesData: climbingRoutesData)
                            .tabItem {
                                Label("Charts",
                                      systemImage: "chart.pie.fill")
                            }
                    }
                }
            }
        }
    }
}
