import Foundation
import SwiftData

@Model
final class LibraryItem {
    var title: String
    var systemImage: String
    var dateAdded: Date
    var isSystemItem: Bool
    var libraryItemType: LibraryItemType
    
    @Relationship(deleteRule: .nullify) var playlists: [Playlist]? = nil
    @Relationship(deleteRule: .nullify) var songs: [Song]? = nil
    
    init(
        title: String,
        systemImage: String,
        dateAdded: Date = Date(),
        libraryItemType: LibraryItemType,
        isSystemItem: Bool
    ) {
        self.title = title
        self.systemImage = systemImage
        self.dateAdded = dateAdded
        self.isSystemItem = isSystemItem
        self.libraryItemType = libraryItemType
    }
}
