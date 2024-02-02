import SwiftUI

enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(Error)
}
