import SwiftUI
import SwiftData

@Model
final class Playlist {
    var title: String
    var details: String?
    var dateAdded: Date
    
    @Relationship(deleteRule: .nullify)
    var songs: [Song] = []
    
    init(title: String, details: String? = nil, dateAdded: Date = .now) {
        self.title = title
        self.details = details
        self.dateAdded = dateAdded
    }
}
