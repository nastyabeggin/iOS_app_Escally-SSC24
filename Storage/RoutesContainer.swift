import SwiftData
import Foundation

actor RoutesContainer {

    let dataContainer: DataContainer

    init() async throws {
        self.dataContainer = try DataContainer(types: [ClimbingRoute.self])
    }

    func addRoute(_ route: ClimbingRoute) async throws {
        try await dataContainer.add(items: [route])
    }

    func fetchRoutes() -> [ClimbingRoute] {
        dataContainer.fetch(ClimbingRoute.self)
    }
}
