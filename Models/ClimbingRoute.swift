import Foundation
import PhotosUI
import SwiftUI
import SwiftData

@Model
class ClimbingRoute: Identifiable, Hashable {
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
    var image: Data?
    var routeDots: [CGPoint]?

    init(id: UUID = UUID(),
         name: String,
         difficulty: RouteDifficulty,
         image: Data? = nil,
         date: Date,
         succeeded: Bool,
         flashed: Bool,
         notes: String,
         routeDots: [CGPoint]? = nil) {
        self.id = id
        self.name = name
        self.difficulty = difficulty
        self.image = image
        self.date = date
        self.succeeded = succeeded
        self.flashed = flashed
        self.notes = notes
        self.routeDots = routeDots
    }

    func copy() -> ClimbingRoute {
        ClimbingRoute(
            id: id,
            name: name,
            difficulty: difficulty,
            image: image,
            date: date,
            succeeded: succeeded,
            flashed: flashed,
            notes: notes,
            routeDots: routeDots
        )
    }

    func update(from draft: ClimbingRoute) {
        name = draft.name
        image = draft.image
        date = draft.date
        difficulty = draft.difficulty
        flashed = draft.flashed
        succeeded = draft.succeeded
        notes = draft.notes
        routeDots = draft.routeDots
    }

    static func == (lhs: ClimbingRoute, rhs: ClimbingRoute) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
