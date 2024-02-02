import SwiftUI

@main
struct MyApp: App {
    @State var showWelcome = false
    @State var climbingRoutesData = ClimbingRoutesData()
    
    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView(showWelcomeView: $showWelcome)
            } else {
                TabView {
                    Group {
                        ClimbingRoutesView(climbingRoutesData: climbingRoutesData)
                            .tabItem {
                                Label("Climbing", systemImage: "mountain.2")
                            }
                        Text("Tab 2")
                            .tabItem {
                                Label("Tab 2",
                                      systemImage: "house")
                            }
                    }
                }
            }
        }
    }
}
