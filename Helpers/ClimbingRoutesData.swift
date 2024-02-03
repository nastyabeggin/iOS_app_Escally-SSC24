import SwiftUI
import Combine

class ClimbingRoutesData: ObservableObject {
    @Published var climbingRoutes: [ClimbingRoute] = []
    @Published var selectedSortOption: SortOption = .byDate
    @Published var sortedRoutes: [ClimbingRoute] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $climbingRoutes
            .combineLatest($selectedSortOption)
            .map { (routes, sortOption) -> [ClimbingRoute] in
                switch sortOption {
                case .byDate:
                    return routes.sorted { $0.date > $1.date }
                case .byName:
                    return routes.sorted { $0.name < $1.name }
                }
            }
            .assign(to: \.sortedRoutes, on: self)
            .store(in: &cancellables)
    }
    
    func changeSortOption(to option: SortOption) {
        selectedSortOption = option
    }
    
    func removeItem(id: UUID) {
        climbingRoutes.remove(at: climbingRoutes.firstIndex(where: {  $0.id == id })!)
    }
}
