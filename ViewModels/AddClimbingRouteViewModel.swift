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

    init(currentClimbingRoute: ClimbingRoute = ClimbingRoute(name: "", difficulty: .yellow, date: Date(), succeeded: true, flashed: false, notes: "", routeDots: [])) {
        self.currentClimbingRoute = currentClimbingRoute
    }

    func saveRoute(context: ModelContext) {
        let routeImageData: Data? = {
            if case .success(let imageData) = imageState {
                return imageData
            } else {
                return nil
            }
        }()
        currentClimbingRoute.image = routeImageData
        context.insert(currentClimbingRoute)
    }

    func removeSelectedImage() {
        imageState = .empty
    }

    private func loadImage(from item: PhotosPickerItem) {
        imageState = .loading(Progress(totalUnitCount: 1))
        item.loadTransferable(type: Data.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data {
                        self?.imageState = .success(data)
                    } else {
                        self?.imageState = .failure(TransferError.importFailed)
                    }
                case .failure(let error):
                    self?.imageState = .failure(error)
                }
            }
        }
    }
}
