import Foundation
import PhotosUI
import SwiftUI

struct ClimbingRoute: Identifiable {
    let id: UUID
    var name: String
    var difficulty: RouteDifficulty
    var date: Date
    var succeeded: Bool {
        didSet {
            flashed = succeeded && flashed
        }
    }
    var flashed: Bool
    var notes: String
    var image: Image?
    
    init(id: UUID = UUID(),
         name: String,
         difficulty: RouteDifficulty,
         image: Image? = nil,
         date: Date,
         succeeded: Bool,
         flashed: Bool,
         notes: String
    ) {
        self.id = id
        self.name = name
        self.difficulty = difficulty
        self.image = image
        self.date = date
        self.succeeded = succeeded
        self.flashed = flashed
        self.notes = notes
    }
}

extension ClimbingRoute: Hashable {
    static func == (lhs: ClimbingRoute, rhs: ClimbingRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
