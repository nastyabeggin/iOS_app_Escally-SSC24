import SwiftUI
import PhotosUI
import Combine

class ClimbingRouteViewModel: ObservableObject {
    @State var selectedRoute: ClimbingRoute
    @Published var showConfirmationDialog = false
    @Published var draftRoute: ClimbingRoute
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

    init(climbingRoute: ClimbingRoute) {
        self.selectedRoute = climbingRoute
        self.draftRoute = climbingRoute.copy()
        if let image = climbingRoute.image {
            imageState = .success(image)
        }
    }

    func saveDraftRoute() {
        selectedRoute.update(from: draftRoute)
    }

    private func loadImage(from item: PhotosPickerItem) {
        imageState = .loading(Progress(totalUnitCount: 1))
        item.loadTransferable(type: Data.self) { [weak self] result in
            self?.handleImageLoadResult(result)
        }
    }

    private func handleImageLoadResult(_ result: Result<Data?, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                if let data = data, UIImage(data: data) != nil {
                    self.imageState = .success(data)
                    self.updateRouteImage(data)
                } else {
                    self.imageState = .failure(TransferError.importFailed)
                }
            case .failure(let error):
                self.imageState = .failure(error)
            }
        }
    }

    private func updateRouteImage(_ imageData: Data) {
        selectedRoute.image = imageData
    }
}
