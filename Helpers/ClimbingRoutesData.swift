import SwiftUI
import Observation

class ClimbingRoutesData: ObservableObject {
    @Published var climbingRoutes: [ClimbingRoute] = []
    
    func removeItem(id: UUID) {
        climbingRoutes.remove(at: climbingRoutes.firstIndex(where: {  $0.id == id })!)
    }
}
