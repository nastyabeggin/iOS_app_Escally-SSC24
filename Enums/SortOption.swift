enum SortOption: String, CaseIterable, Identifiable {
    case byName = "Name"
    case byDate = "Date"
    
    var id: SortOption { self }
}
