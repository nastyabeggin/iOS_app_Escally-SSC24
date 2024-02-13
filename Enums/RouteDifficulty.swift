import SwiftUI


enum RouteDifficulty: String, CaseIterable, Identifiable, Codable {
    case yellow = "Yellow"
    case green = "Green"
    case blue = "Blue"
    case red = "Red"
    case purple = "Purple"
    case black = "Black"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .red: return .red
        case .purple: return .purple
        case .black: return .primary
        }
    }
}

extension RouteDifficulty: Comparable {
    private var sortOrder: Int {
        switch self {
        case .yellow: return 0
        case .green: return 1
        case .blue: return 2
        case .red: return 3
        case .purple: return 4
        case .black: return 6
        }
    }
    
    static func == (lhs: RouteDifficulty, rhs: RouteDifficulty) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }
    
    static func < (lhs: RouteDifficulty, rhs: RouteDifficulty) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
}
