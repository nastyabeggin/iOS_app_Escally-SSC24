import Foundation

struct RoutesByColor: Identifiable, Equatable {
    let id = UUID()
    let difficulty: RouteDifficulty
    let count: Int
}
