import Foundation

@frozen public enum SearchCategoryType: String, CaseIterable, Identifiable {
    case songs, playlists
    
    public var id: Self {
        return self
    }
    
    var description: String {
        switch self {
        case .songs:
            return "Songs"
        case .playlists:
            return "Playlists"
        }
    }
}
