import XCTest
import SwiftData

@testable import Escally

final class RoutesContainerTests: XCTestCase {

    var routesContainer: RoutesContainer!

    override func setUpWithError() async throws {
        routesContainer = try await RoutesContainer()
    }

    override func tearDownWithError() throws {
        routesContainer = nil
    }

    func testAddRoute() async throws {
        let route = ClimbingRoute(name: "Test Route", difficulty: .red, date: .now, succeeded: true, flashed: false, notes: "")
        
        try await routesContainer.addRoute(route)

        let fetchedRoutes = routesContainer.fetchRoutes()
        XCTAssertEqual(fetchedRoutes.count, 1)
        XCTAssertEqual(fetchedRoutes.first?.name, "Test Route")
    }

    func testFetchEmptyRoutes() async throws {
        let fetchedRoutes = routesContainer.fetchRoutes()
        XCTAssertTrue(fetchedRoutes.isEmpty)
    }

    func testAddAndFetchMultipleRoutes() async throws {
        let routes = [
            ClimbingRoute(name: "Route 1", difficulty: .yellow, date: .now, succeeded: true, flashed: false, notes: ""),
            ClimbingRoute(name: "Route 2", difficulty: .blue, date: .now, succeeded: false, flashed: false, notes: "")
        ]

        for route in routes {
            try await routesContainer.addRoute(route)
        }

        let fetchedRoutes = routesContainer.fetchRoutes()
        XCTAssertEqual(fetchedRoutes.count, 2)
        XCTAssertEqual(fetchedRoutes[0].name, "Route 1")
        XCTAssertEqual(fetchedRoutes[1].name, "Route 2")
    }
}
