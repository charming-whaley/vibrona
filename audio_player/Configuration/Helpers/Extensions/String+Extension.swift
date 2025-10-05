import Foundation

extension String {
    var removeFileExtension: String? {
        guard let period = lastIndex(of: ".") else {
            return nil
        }
        
        return String(self[..<period])
    }
}
