import SwiftUI
import SwiftData

@Model
final class Song {
    @Attribute(.unique) var id: UUID
    var title: String
    var artist: String
    var duration: TimeInterval?
    var filePath: String
    var dateAdded: Date
    var playCount: Int
    var lastPlayed: Date?
    
    @Relationship(deleteRule: .nullify, inverse: \Playlist.songs)
    var playlists: [Playlist] = []
    
    init(
        title: String,
        artist: String,
        duration: TimeInterval? = nil,
        filePath: String,
        dateAdded: Date = .now,
        playCount: Int = 0,
        lastPlayed: Date? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.artist = artist
        self.duration = duration
        self.filePath = filePath
        self.dateAdded = dateAdded
        self.playCount = playCount
        self.lastPlayed = lastPlayed
    }
}
