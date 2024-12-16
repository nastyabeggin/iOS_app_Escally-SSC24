import XCTest
import SwiftData

@testable import Escally

final class DataContainerTests: XCTestCase {

    var dataContainer: DataContainer!

    override func setUpWithError() throws {
        dataContainer = try DataContainer(types: [ClimbingRoute.self], isInMemory: true)
    }

    override func tearDownWithError() throws {
        dataContainer = nil
    }

    func testAddAndFetchRoutes() async throws {
        let route = ClimbingRoute(name: "Test Route", difficulty: .red, date: .now, succeeded: true, flashed: false, notes: "Test note")
        
        try await dataContainer.add(items: [route])

        let fetchedRoutes = dataContainer.fetch(ClimbingRoute.self)
        XCTAssertEqual(fetchedRoutes.count, 1)
        XCTAssertEqual(fetchedRoutes.first?.name, "Test Route")
    }

    func testAddMultipleRoutes() async throws {
        let routes = [
            ClimbingRoute(name: "Route 1", difficulty: .yellow, date: .now, succeeded: true, flashed: false, notes: ""),
            ClimbingRoute(name: "Route 2", difficulty: .blue, date: .now, succeeded: false, flashed: false, notes: "")
        ]
        
        try await dataContainer.add(items: routes)

        let fetchedRoutes = dataContainer.fetch(ClimbingRoute.self)
        XCTAssertEqual(fetchedRoutes.count, 2)
        XCTAssertEqual(fetchedRoutes[0].name, "Route 1")
        XCTAssertEqual(fetchedRoutes[1].name, "Route 2")
    }

    func testEmptyFetch() throws {
        let fetchedRoutes = dataContainer.fetch(ClimbingRoute.self)
        XCTAssertTrue(fetchedRoutes.isEmpty)
    }

    func testAddInvalidModel() async throws {
        struct RoutesButton: PersistentModel {}
        
        do {
            let invalidItem = RoutesButton()
            try await dataContainer.add(items: [invalidItem])
            XCTFail("Adding an invalid model should throw an error")
        } catch {
            XCTAssertTrue(true, "Error correctly thrown")
        }
    }
}
