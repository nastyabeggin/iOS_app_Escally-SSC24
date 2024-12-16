import SwiftData
import Foundation

struct PreviewContainer {

    let container: ModelContainer

    init(_ types: [any PersistentModel.Type]) throws {
        self.container = try configureContainer(with: types)
        addPreviewData()
    }

    private func configureContainer(with types: [any PersistentModel.Type]) throws -> ModelContainer {
        do {
            let schema = Schema(types)
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            Logger.error("Failed to configure container: \(error.localizedDescription)")
            throw ModelContainerError.schemaInitializationFailed
        }
    }

    private func add(items: [any PersistentModel]) {
        Task { @MainActor in
            for item in items {
                do {
                    container.mainContext.insert(item)
                } catch {
                    throw ModelContainerError.itemInsertionFailed("Failed to insert item \(item)")
                }
            }
            do {
                try container.mainContext.save()
            } catch {
                throw ModelContainerError.contextSaveFailed
            }
        }
    }

    private func previewData() -> [ClimbingRoute] {
        [
            ClimbingRoute(name: "", difficulty: .red, date: Calendar.current.date(byAdding: .day, value: -6, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .red, date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .red, date: Calendar.current.date(byAdding: .day, value: -10, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .yellow, date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, succeeded: true, flashed: true, notes: ""),
            ClimbingRoute(name: "", difficulty: .purple, date: Calendar.current.date(byAdding: .day, value: -2, to: .now)!, succeeded: true, flashed: true, notes: "")
        ]
    }

    private func addPreviewData() {
        do {
            addItems(previewData())
        } catch {
            Logger.error("Failed to add preview data: \(error.localizedDescription)")
        }
    }
}
