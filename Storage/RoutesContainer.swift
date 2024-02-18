import Foundation
import SwiftData

actor RoutesContainer {
    
    @MainActor
    static func create() -> ModelContainer {
        do {
            let schema = Schema([ClimbingRoute.self])
            let configuration = ModelConfiguration()
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return container
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
}
