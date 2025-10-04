import Foundation
import SwiftData

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
}
