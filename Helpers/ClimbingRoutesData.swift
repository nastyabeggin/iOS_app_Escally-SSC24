import SwiftUI
import Observation

@Observable class ClimbingRoutesData {
    var climbingRoutes: [ClimbingRoute] = []
    
    func removeItem(id: UUID) {
        climbingRoutes.remove(at: climbingRoutes.firstIndex(where: {  $0.id == id })!)
    }
}
