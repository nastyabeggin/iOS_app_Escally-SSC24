import SwiftUI
import PhotosUI
import Combine

class ClimbingRouteViewModel: ObservableObject {
    @State var climbingRoutesData: ClimbingRoutesData
    @Published var selectedRoute: ClimbingRoute
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

    var id: UUID?
    private var cancellables: Set<AnyCancellable> = []

    init(climbingRoutesData: ClimbingRoutesData, climbingRoute: ClimbingRoute) {
        self.climbingRoutesData = climbingRoutesData
        self.selectedRoute = climbingRoute
        if let image = climbingRoute.image {
            imageState = .success(image)
        }
        setupSubscriptions()
    }

    deinit {
        
    }
    
    func remove() {
        guard let index = climbingRoutesData.climbingRoutes.firstIndex(where: { $0.id == selectedRoute.id }) else { return }
        climbingRoutesData.climbingRoutes.remove(at: index)
    }
    
    func updateRoute(updatedRoute: ClimbingRoute) {
        guard let index = climbingRoutesData.climbingRoutes.firstIndex(where: { $0.id == updatedRoute.id }) else { return }
        climbingRoutesData.climbingRoutes[index] = updatedRoute
    }

    
    private func loadImage(from item: PhotosPickerItem) {
        imageState = .loading(Progress(totalUnitCount: 1))
        item.loadTransferable(type: Data.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        self?.imageState = .success(Image(uiImage: uiImage))
                    } else {
                        self?.imageState = .failure(TransferError.importFailed)
                    }
                case .failure(let error):
                    self?.imageState = .failure(error)
                }
            }
        }
    }

    private func setupSubscriptions() {
        $selectedRoute
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
