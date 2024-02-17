import Foundation

enum TimeRange: String, CaseIterable, Identifiable {
    case week = "W"
    case month = "M"
    case sixMonths = "6M"
    case year = "Y"

    var id: String {
        self.rawValue
    }

    var description: String {
        self.rawValue
    }
}
