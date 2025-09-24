import Foundation
import SwiftData

@Model
final class LibraryItem {
    var title: String
    var systemImage: String
    
    init(title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }
}
