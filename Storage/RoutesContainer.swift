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
            Logger.error("Failed to configure RoutesContainer: \(error.localizedDescription)")
            throw ModelContainerError.schemaInitializationFailed
        }
    }
}
