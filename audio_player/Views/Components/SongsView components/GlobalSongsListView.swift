import SwiftUI
import SwiftData

struct GlobalSongsListView: View {
    @Query(sort: \Song.title) var songs: [Song]
    
    @State private var songsSortOrder: SongSortOrder = .title
    @State private var searchQuery: String = ""
    @State private var currentSong: Song?
    
    private var processedSongsList: [Song] {
        return DataController.shared.retrieveProcessedSongsList(of: songs, by: searchQuery) {
            switch songsSortOrder {
            case .title:
                $0.title < $1.title
            case .artist:
                $0.artist < $1.artist
            case .dateAdded:
                $0.dateAdded < $1.dateAdded
            case .playCount:
                $0.playCount < $1.playCount
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if songs.isEmpty {
                    NoSongsView()
                } else {
                    SongsCollectionView(edges: [.bottom]) {
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
