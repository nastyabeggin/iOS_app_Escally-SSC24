enum SortOption: String, CaseIterable, Identifiable {
    case byName = "Name"
    case byDate = "Date"
    case byDifficulty = "Difficulty"
    case bySuccess = "Succeeded"

    var id: Self { self }
}
