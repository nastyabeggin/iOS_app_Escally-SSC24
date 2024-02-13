import SwiftUI
import PhotosUI
import Combine

class ClimbingRouteViewModel: ObservableObject {
    @State var selectedRoute: ClimbingRoute
    @Published var showConfirmationDialog: Bool
    @Published var draftRoute: ClimbingRoute
    @Published var imageState: ImageState = .empty
    @Published var selectedPickerItem: PhotosPickerItem? = nil {
        didSet {
            guard let item = selectedPickerItem else {
                imageState = .empty
                return
            }
            loadImage(from: item)
        }
    }

    init(climbingRoute: ClimbingRoute) {
        self.showConfirmationDialog = false
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
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let _ = UIImage(data: data) {
                        self.imageState = .success(data)
                        self.selectedRoute.image = data
                    } else {
                        self.imageState = .failure(TransferError.importFailed)
                    }
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }

    private func updateRouteImage(_ imageData: Data) {
        selectedRoute.image = imageData
    }
}
