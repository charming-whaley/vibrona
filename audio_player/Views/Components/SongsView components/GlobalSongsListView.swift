import SwiftUI
import SwiftData

struct GlobalSongsListView: View {
    @Query(sort: \Song.title) var songs: [Song]
    
    @State private var songsSortOrder: SongSortOrder = .title
    @State private var searchQuery: String = ""
    @State private var currentSong: Song?
    
    var processedSongsList: [Song] {
        var filteredSongsList = [Song]()
        if searchQuery.isEmpty {
            filteredSongsList = songs
        } else {
            filteredSongsList = songs.filter { song in
                song.title.localizedStandardContains(searchQuery) || song.artist.localizedStandardContains(searchQuery) || searchQuery.isEmpty
            }
        }
        
        let sortedSongsList = switch songsSortOrder {
        case .title:
            filteredSongsList.sorted { $0.title < $1.title }
        case .artist:
            filteredSongsList.sorted { $0.artist < $1.artist }
        case .dateAdded:
            filteredSongsList.sorted { $0.dateAdded < $1.dateAdded }
        case .playCount:
            filteredSongsList.sorted { $0.playCount < $1.playCount }
        }
        
        return sortedSongsList
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if songs.isEmpty {
                    ContentUnavailableView("No Songs...", systemImage: "music.note.list")
                } else {
                    ScrollView(.vertical) {
                        LazyVStack {
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
                                                currentSong = song
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
                    }
                }
            }
            .navigationTitle("Songs")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, prompt: Text("Search songs..."))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("", selection: $songsSortOrder) {
                            ForEach(SongSortOrder.allCases) { songSortOrder in
                                Text("Sort by \(songSortOrder.description)")
                                    .tag(songSortOrder)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(item: $currentSong, content: { song in
                SongPlaylistSelectionView(song: song)
            })
        }
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return GlobalSongsListView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
