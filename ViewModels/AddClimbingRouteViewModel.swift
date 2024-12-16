import SwiftUI
import SwiftData
import PhotosUI

class AddClimbingRouteViewModel: ObservableObject {
    @Published var currentClimbingRoute: ClimbingRoute
    @Published var imageState: ImageState = .empty
    @Published var selectedPickerItem: PhotosPickerItem? {
        didSet {
            guard let item = selectedPickerItem else {
                imageState = .empty
                return
            }
            loadImage(from: item)
        }
    }

    init(currentClimbingRoute: ClimbingRoute = ClimbingRoute(
        name: "",
        difficulty: .yellow,
        date: Date(),
        succeeded: true,
        flashed: false,
        notes: "",
        routeDots: []
    )) {
        self.currentClimbingRoute = currentClimbingRoute
    }

    func saveRoute(context: ModelContext) {
        if case .success(let imageData) = imageState {
            currentClimbingRoute.image = imageData
        }
        context.insert(currentClimbingRoute)
    }

    func removeSelectedImage() {
        imageState = .empty
    }

    private func loadImage(from item: PhotosPickerItem) {
        imageState = .loading(Progress(totalUnitCount: 1))
        item.loadTransferable(type: Data.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleImageLoadResult(result)
            }
        }
    }

    private func handleImageLoadResult(_ result: Result<Data?, Error>) {
        switch result {
        case .success(let data):
            imageState = data != nil ? .success(data!) : .failure(TransferError.importFailed)
        case .failure(let error):
            imageState = .failure(error)
        }
    }
}
