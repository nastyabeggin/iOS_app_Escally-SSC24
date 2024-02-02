import SwiftUI
import PhotosUI

class AddClimbingRouteViewModel: ObservableObject {
    @State var climbingRoutesData: ClimbingRoutesData
    @Published var name: String = ""
    @Published var difficulty: RouteDifficulty = .yellow
    @Published var imageState: ImageState = .empty
    @Published var date: Date = .now
    @Published var succeeded: Bool = true
    @Published var flashed: Bool = false
    @Published var notes: String = ""
    @Published var selectedPickerItem: PhotosPickerItem? = nil {
        didSet {
            guard let item = selectedPickerItem else {
                imageState = .empty
                return
            }
            loadImage(from: item)
        }
    }
    
    init(climbingRoutesData: ClimbingRoutesData) {
        self.climbingRoutesData = climbingRoutesData
    }
    
    func saveRoute() {
        let routeImage: Image? = {
            if case .success(let image) = imageState {
                return image
            } else {
                return nil
            }
        }()
        
        let newRoute = ClimbingRoute(
            name: name,
            difficulty: difficulty,
            image: routeImage,
            date: date,
            succeeded: succeeded,
            flashed: flashed,
            notes: notes
        )
        
        climbingRoutesData.climbingRoutes.append(newRoute)
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
}
