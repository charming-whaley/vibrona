import SwiftUI

@frozen public enum LibraryItemType: String, CaseIterable, Identifiable, Codable {
    case playlist, album, songs
    
    public var id: Self {
        return self
    }
    
    public var description: String {
        switch self {
        case .playlist:
            return "Playlist"
        case .album:
            return "Album"
        case .songs:
            return "Songs list"
        }
    }
}
