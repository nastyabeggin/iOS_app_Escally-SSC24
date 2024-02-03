enum SortOption: String, CaseIterable, Identifiable {
    case byName = "Name"
    case byDate = "Date"
    case byDifficulty = "Difficulty"
    case bySuccess = "Successed"
    
    var id: SortOption { self }
}
