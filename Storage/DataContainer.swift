import SwiftData
import Foundation

struct DataContainer {

    let container: ModelContainer

    init(types: [any PersistentModel.Type], isInMemory: Bool = false) throws {
        do {
            let schema = Schema(types)
            let configuration = ModelConfiguration(isStoredInMemoryOnly: isInMemory)
            self.container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            throw DataContainerError.initializationFailed(error.localizedDescription)
        }
    }

    func add(items: [any PersistentModel]) async throws {
        try await Task { @MainActor in
            for item in items {
                container.mainContext.insert(item)
            }
            try container.mainContext.save()
        }.value
    }

    func fetch<T: PersistentModel>(_ type: T.Type) -> [T] {
        container.mainContext.fetch(T.self)
    }
}

enum DataContainerError: Error {
    case initializationFailed(String)
}
