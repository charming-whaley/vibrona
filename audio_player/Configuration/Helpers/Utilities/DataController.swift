import Foundation
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
}
