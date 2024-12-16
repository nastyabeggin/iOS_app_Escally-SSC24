import Foundation

enum TransferError: Error {
    case importFailed
}

enum ModelContainerError: Error {
    case schemaInitializationFailed
    case itemInsertionFailed(String)
    case contextSaveFailed
}
