import SwiftUI
import SwiftData

struct PlaylistView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var addsSongsToPlaylist: Bool = false
    @State private var songsSortOrder: SongSortOrder = .title
    @State private var searchQuery: String = ""
    
    let playlist: Playlist
    
    var processedSongsList: [Song] {
        var filteredSongsList = [Song]()
        if searchQuery.isEmpty {
            filteredSongsList = playlist.songs
        } else {
            filteredSongsList = playlist.songs.filter { song in
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
            ScrollView(.vertical) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("AppDarkGrayColor"))
                    .clipShape(.rect(cornerRadius: 12))
                    .frame(width: 300, height: 300)
                    .overlay(alignment: .center) {
                        Image(systemName: "music.note")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    }
                    .padding(16)
                
                Text(playlist.title)
                    .font(.title3.bold())
                    .padding(.bottom, 12)
                
                Divider()
                    .padding(.horizontal)
                
                Button {
                    addsSongsToPlaylist.toggle()
                } label: {
                    AddSongToPlaylistButtonView()
                }
                
                LazyVStack(spacing: 16) {
                    ForEach(processedSongsList) { song in
                        SongItemView(song: song) {
                            Menu {
                                Button {
                                    
                                } label: {
                                    Label("Play next", systemImage: "play.fill")
                                }
                                
                                Button {
                                    
                                } label: {
                                    Label("Hide", systemImage: "eye.slash.fill")
                                }
                                
                                Button(role: .destructive) {
                                    
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
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
            .sheet(isPresented: $addsSongsToPlaylist) {
                PlaylistSongSelectionView(playlist: playlist)
            }
        }
    }
    
    @ViewBuilder private func AddSongToPlaylistButtonView(_ size: CGSize = .init(width: 30, height: 30)) -> some View {
        HStack(spacing: 15) {
            HStack(spacing: 12) {
                Circle()
                    .frame(width: size.width, height: size.height)
                    .foregroundStyle(.gray)
                    .overlay(alignment: .center) {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                
                Text("Add Songs")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("AppDarkGrayColor"))
        }
        .padding(.horizontal)
        .contentShape(.rect)
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return PlaylistView(playlist: .init(title: "Some funny playlist", details: "Some things rise very rich and strong men"))
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
