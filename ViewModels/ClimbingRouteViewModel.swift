import SwiftUI
import PhotosUI
import Combine

class ClimbingRouteViewModel: ObservableObject {
    @State var climbingRoutesData: ClimbingRoutesData
    @Binding var selectedRoute: ClimbingRoute
    @Published var showConfirmationDialog: Bool = false
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

    init(climbingRoutesData: ClimbingRoutesData, climbingRoute: Binding<ClimbingRoute>) {
        self.climbingRoutesData = climbingRoutesData
        self._selectedRoute = climbingRoute
        self.draftRoute = climbingRoute.wrappedValue
        if let image = climbingRoute.wrappedValue.image {
            imageState = .success(image)
        }
    }

    func saveDraftRoute() {
        guard let index = climbingRoutesData.climbingRoutes.firstIndex(where: { $0.id == draftRoute.id }) else { return }
        climbingRoutesData.climbingRoutes[index] = draftRoute
    }

    
    private func loadImage(from item: PhotosPickerItem) {
        imageState = .loading(Progress(totalUnitCount: 1))
        item.loadTransferable(type: Data.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        self?.imageState = .success(Image(uiImage: uiImage))
                        self?.updateRouteImage(Image(uiImage: uiImage))
                    } else {
                        self?.imageState = .failure(TransferError.importFailed)
                    }
                case .failure(let error):
                    self?.imageState = .failure(error)
                }
            }
        }
    }

    private func updateRouteImage(_ image: Image) {
        selectedRoute.image = image
        
        if let index = climbingRoutesData.climbingRoutes.firstIndex(where: { $0.id == selectedRoute.id }) {
            climbingRoutesData.climbingRoutes[index].image = image
        }
    }
}
