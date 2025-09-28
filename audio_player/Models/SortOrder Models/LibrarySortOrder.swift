import SwiftUI

@frozen public enum LibrarySortOrder: String, Identifiable, CaseIterable {
    case title, dateAdded
    
    public var id: Self {
        return self
    }
    
    public var description: String {
        switch self {
        case .title:
            return "name"
        case .dateAdded:
            return "date"
        }
    }
}
