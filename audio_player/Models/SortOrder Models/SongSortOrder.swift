import SwiftUI

@frozen public enum SongSortOrder: String, Identifiable, CaseIterable {
    case title, artist, dateAdded, playCount
    
    public var id: Self {
        return self
    }
    
    public var description: String {
        switch self {
        case .title:
            return "name"
        case .artist:
            return "artist"
        case .dateAdded:
            return "date"
        case .playCount:
            return "plays number"
        }
    }
}
