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

extension TimeRange {
    func toTimeInterval() -> TimeInterval {
        switch self {
        case .week:
            return -7 * 24 * 60 * 60
        case .month:
            return -30 * 24 * 60 * 60
        case .sixMonths:
            return -6 * 30 * 24 * 60 * 60
        case .year:
            return -365 * 24 * 60 * 60
        }
    }
}
