import SwiftUI

enum ImportFileError: Error, LocalizedError {
    case importFilesFailure
    case contextSavingFailure
    case brokenURL
    
    public var errorDescription: String? {
        switch self {
        case .importFilesFailure:
            return "Couldn't import chosen audio files!"
        case .contextSavingFailure:
            return "Couldn't save audio files to library!"
        case .brokenURL:
            return "Couldn't save audio files from the provided link!"
        }
    }
}
