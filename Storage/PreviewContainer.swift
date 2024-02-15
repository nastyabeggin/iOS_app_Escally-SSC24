import SwiftData
import Foundation

struct PreviewContainer {
    
    let container: ModelContainer!
    
    init(_ types: [any PersistentModel.Type]) {
        let schema = Schema(types)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])
        self.add(items: [
            ClimbingRoute(name: "", difficulty: .red, date: Calendar.current.date(byAdding: .day, value: -6, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .red, date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .red, date: Calendar.current.date(byAdding: .day, value: -10, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .yellow, date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .purple, date: Calendar.current.date(byAdding: .day, value: -2, to: .now)!, succeeded: true, flashed: true, notes: "")
        ])
    }
    
    private func add(items: [any PersistentModel]) {
        Task { @MainActor in
            items.forEach { container.mainContext.insert($0) }
        }
    }
}
