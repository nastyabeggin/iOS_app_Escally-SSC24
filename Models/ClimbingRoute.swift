import Foundation
import PhotosUI
import SwiftUI
import UIKit

class ClimbingRoute: Identifiable, Hashable, ObservableObject {
    let id: UUID
    var name: String
    var difficulty: RouteDifficulty
    var date: Date
    var succeeded: Bool
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
    
    static func == (lhs: ClimbingRoute, rhs: ClimbingRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
