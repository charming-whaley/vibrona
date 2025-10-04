import SwiftUI
import SwiftData

struct SearchResultListView: View {
    @Query var playlists: [Playlist]
    @Query var songs: [Song]
    
    @State private var selectedSong: Song?
    @Binding var currentCategory: SearchCategoryType
    
    var searchQuery: String
    private let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]
    private var processedPlaylistsList: [Playlist] {
        return DataController.shared.retrieveProcessedPlaylistsList(of: playlists, by: searchQuery)
    }
    private var processedSongsList: [Song] {
        return DataController.shared.retrieveProcessedSongsList(of: songs, by: searchQuery)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch currentCategory {
                case .songs:
                    SongsCollectionView {
                        ForEach(processedSongsList) { song in
                            Button {
                                
                            } label: {
                                SongItemView(song: song) {
                                    Menu {
                                        Button {
                                            
                                        } label: {
                                            Label("Play next", systemImage: "play.fill")
                                        }
                                        
                                        Button {
                                            selectedSong = song
                                        } label: {
                                            Label("Add to Playlist", systemImage: "music.pages.fill")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                            .contentShape(.rect)
                                    }
                                }
                            }
                        }
                    }
                case .playlists:
                    PlaylistsCollectionView(columns: columns) {
                        ForEach(processedPlaylistsList) { playlist in
                            NavigationLink {
                                PlaylistView(playlist: playlist)
                            } label: {
                                MiniPlaylistItemView(playlist: playlist)
                            }
                        }
                    }
                }
            }
            .sheet(item: $selectedSong) { song in
                SongPlaylistSelectionView(song: song)
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Playlist.self, Song.self)
    preview.insert(Playlist.playlists)
    preview.insert(Song.songs)
    
    return SearchResultListView(currentCategory: .constant(.songs), searchQuery: "")
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
