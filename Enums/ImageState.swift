import Foundation

enum ImageState {
    case empty
    case loading(Progress)
    case success(Data)
    case failure(Error)
}
