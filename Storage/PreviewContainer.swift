import SwiftData
import Foundation

struct PreviewContainer {

    let dataContainer: DataContainer

    init() {
        do {
            self.dataContainer = try DataContainer(types: [ClimbingRoute.self], isInMemory: true)
            Task {
                try await self.addPreviewData()
            }
        } catch {
            Logger.error("Failed to initialize PreviewContainer: \(error.localizedDescription)")
        }
    }

    private func addPreviewData() async throws {
        let previewRoutes = [
            ClimbingRoute(name: "Route 1", difficulty: .red, date: Calendar.current.date(byAdding: .day, value: -6, to: .now) ?? .now, succeeded: true, flashed: true, notes: "Challenging route"),
            ClimbingRoute(name: "Route 2", difficulty: .yellow, date: Calendar.current.date(byAdding: .day, value: -5, to: .now) ?? .now, succeeded: true, flashed: false, notes: "Technical climb"),
            ClimbingRoute(name: "Route 3", difficulty: .blue, date: Calendar.current.date(byAdding: .day, value: -10, to: .now) ?? .now, succeeded: false, flashed: false, notes: ""),
            ClimbingRoute(name: "Route 4", difficulty: .purple, date: Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? .now, succeeded: true, flashed: true, notes: "Long endurance route")
        ]
        try await dataContainer.add(items: previewRoutes)
    }
}
