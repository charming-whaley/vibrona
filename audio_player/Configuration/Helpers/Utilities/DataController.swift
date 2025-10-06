import Foundation
import SwiftUI
import SwiftData
import AVFoundation

final class DataController {
    
    static let shared = DataController()
    
    public func retrieveProcessedSongsList(of songs: [Song]?, by searchQuery: String, _ sort: ((Song, Song) -> Bool)? = nil) -> [Song] {
        guard let songs = songs else {
            return []
        }
        
        let filteredSongsList = songs.filter { song in
            return searchQuery.isEmpty || song.title.localizedStandardContains(searchQuery) || song.artist.localizedStandardContains(searchQuery)
        }
        
        guard let sort = sort else {
            return filteredSongsList
        }
        
        return filteredSongsList.sorted(by: sort)
    }
    
    public func retrieveProcessedPlaylistsList(of playlists: [Playlist]?, by searchQuery: String, _ sort: ((Playlist, Playlist) -> Bool)? = nil) -> [Playlist] {
        guard let playlists = playlists else {
            return []
        }
        
        let filteredPlaylistsList = playlists.filter { playlist in
            return searchQuery.isEmpty || playlist.title.localizedStandardContains(searchQuery)
        }
        
        guard let sort = sort else {
            return filteredPlaylistsList
        }
        
        return filteredPlaylistsList.sorted(by: sort)
    }
    
    public func extractMetaData(from url: URL) async -> MP3Metadata {
        let asset = AVURLAsset(url: url)
        
        let duration = try? await asset.load(.duration).seconds
        var title: String?
        var artist: String?
        var coverData: Data?
        
        if let metadata = try? await asset.load(.commonMetadata) {
            for meta in metadata {
                switch meta.commonKey {
                case .commonKeyTitle:
                    title = try? await meta.load(.stringValue)
                case .commonKeyArtist:
                    artist = try? await meta.load(.stringValue)
                case .commonKeyArtwork:
                    if let data = try? await meta.load(.dataValue) {
                        coverData = data
                    }
                default:
                    break
                }
            }
        }
        
        return MP3Metadata(
            title: title,
            artist: artist,
            cover: coverData,
            duration: duration
        )
    }
    
    public func handleImportFiles(
        from result: Result<[URL], Error>,
        into libraryItem: LibraryItem? = nil,
        using modelContext: ModelContext
    ) async throws {
        switch result {
        case .success(let success):
            guard let urls = success.first else {
                throw ImportFileError.brokenURL
            }
            
            guard urls.startAccessingSecurityScopedResource() else {
                throw ImportFileError.brokenURL
            }
            
            defer {
                urls.stopAccessingSecurityScopedResource()
            }
            
            
            do {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destination = documents.appendingPathComponent(urls.lastPathComponent)
                
                if FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                
                try FileManager.default.copyItem(at: urls, to: destination)
                
                let metadata = await DataController.shared.extractMetaData(from: destination)
                let song = Song(
                    title: metadata.title ?? "No title provided",
                    artist: metadata.artist ?? "Unknown artist",
                    duration: metadata.duration ?? 0,
                    filePath: destination.lastPathComponent,
                    fileName: destination.lastPathComponent,
                    coverData: metadata.cover
                )
                
                modelContext.insert(song)
                if let libraryItem = libraryItem {
                    libraryItem.songs?.append(song)
                }
                
                try modelContext.save()
            } catch {
                throw ImportFileError.contextSavingFailure
            }
        case .failure(_):
            throw ImportFileError.importFilesFailure
        }
    }
}
