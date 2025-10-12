import SwiftUI
import SwiftData

@Model
final class Song {
    @Attribute(.unique) var id: UUID
    var title: String
    var artist: String
    var duration: Double?
    var filePath: String
    var dateAdded: Date
    var playCount: Int
    var lastPlayed: Date?
    var fileName: String?
    var coverData: Data?
    var url: URL?
    
    @Relationship(deleteRule: .nullify, inverse: \Playlist.songs) var playlists: [Playlist] = []
    
    init(
        title: String,
        artist: String,
        duration: Double? = nil,
        filePath: String,
        dateAdded: Date = Date(),
        playCount: Int = 0,
        lastPlayed: Date? = nil,
        fileName: String? = nil,
        coverData: Data? = nil,
        url: URL? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.artist = artist
        self.duration = duration
        self.filePath = filePath
        self.dateAdded = dateAdded
        self.playCount = playCount
        self.lastPlayed = lastPlayed
        self.fileName = fileName
        self.coverData = coverData
        self.url = url
    }
    
    var cover: UIImage? {
        if let data = coverData {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
