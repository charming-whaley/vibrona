import Foundation
import SwiftData

@Model
final class LibraryItem {
    var title: String
    var systemImage: String
    var dateAdded: Date = Date.distantPast
    var isSystemItem: Bool
    var libraryItemType: LibraryItemType
    
    @Relationship(deleteRule: .nullify) var playlists: [Playlist]? = nil
    @Relationship(deleteRule: .nullify) var songs: [Song]? = nil
    
    init(title: String, systemImage: String, libraryItemType: LibraryItemType, isSystemItem: Bool) {
        self.title = title
        self.systemImage = systemImage
        self.isSystemItem = isSystemItem
        self.libraryItemType = libraryItemType
    }
}
