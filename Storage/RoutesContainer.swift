import Foundation
import SwiftData

actor RoutesContainer {
    
    @MainActor
    static func create() -> ModelContainer {
        do {
            let schema = Schema([ClimbingRoute.self])
            let configuration = ModelConfiguration()
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
}
