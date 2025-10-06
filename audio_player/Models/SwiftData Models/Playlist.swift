import SwiftUI
import SwiftData

@Model
final class Playlist {
    var title: String
    var details: String?
    var dateAdded: Date
    @Relationship(deleteRule: .nullify) var songs: [Song] = []
    @Attribute(.externalStorage) var coverData: Data?
    
    init(
        title: String,
        details: String? = nil,
        dateAdded: Date = Date(),
        coverData: Data? = nil
    ) {
        self.title = title
        self.details = details
        self.dateAdded = dateAdded
        self.coverData = coverData
    }
    
    var cover: UIImage? {
        if let data = coverData {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
