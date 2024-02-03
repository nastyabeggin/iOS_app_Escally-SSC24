import SwiftUI

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
