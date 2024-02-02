import SwiftUI

enum RouteDifficulty: String, CaseIterable, Identifiable {
    case yellow = "Yellow"
    case green = "Green"
    case blue = "Blue"
    case red = "Red"
    case purple = "Purple"
    case white = "White"
    case black = "Black"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .red: return .red
        case .purple: return .purple
        case .white: return .primary
        case .black: return .primary
        }
    }
}
