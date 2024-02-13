import SwiftUI
import SwiftData
import PhotosUI

class AddClimbingRouteViewModel: ObservableObject {
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
    
    func saveRoute(context: ModelContext) {
        let routeImageData: Data? = {
            if case .success(let imageData) = imageState {
                return imageData
            } else {
                return nil
            }
        }()

        let newRoute = ClimbingRoute(
            name: name,
            difficulty: difficulty,
            image: routeImageData,
            date: date,
            succeeded: succeeded,
            flashed: flashed,
            notes: notes
        )
        context.insert(newRoute)
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
