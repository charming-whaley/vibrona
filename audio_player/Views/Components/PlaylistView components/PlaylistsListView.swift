import SwiftUI
import SwiftData

/// TODO: Update the playlists list, insertion into the context

struct PlaylistsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var libraryItem: LibraryItem
    @Query var playlists: [Playlist]
    
    @State private var playlistsSortOrder: PlaylistSortOrder = .title
    @State private var currentPlaylist: Playlist?
    @State private var addNewPlaylist: Bool = false
    @State private var deletePlaylist: Bool = false
    @State private var searchQuery: String = ""
    
    var processedSongsList: [Playlist] {
        var filteredSongsList = [Playlist]()
        if let playlists = libraryItem.playlists {
            if searchQuery.isEmpty {
                filteredSongsList = playlists
            } else {
                filteredSongsList = playlists.filter { song in
                    song.title.localizedStandardContains(searchQuery) || searchQuery.isEmpty
                }
            }
        }
        
        let sortedPlaylistsList = switch playlistsSortOrder {
        case .title:
            filteredSongsList.sorted { $0.title < $1.title }
        case .dateAdded:
            filteredSongsList.sorted { $0.dateAdded < $1.dateAdded }
        }
        
        return sortedPlaylistsList
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if processedSongsList.isEmpty {
                    ContentUnavailableView("No Playlists...", systemImage: "music.note.list")
                } else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                            ForEach(processedSongsList) { playlist in
                                NavigationLink {
                                    PlaylistView(playlist: playlist)
                                } label: {
                                    MiniPlaylistItemView(item: playlist)
                                }
                                .contextMenu {
                                    Button {
                                        
                                    } label: {
                                        Label("Edit", systemImage: "rectangle.and.pencil.and.ellipsis")
                                    }
                                    
                                    Button(role: .destructive) {
                                        currentPlaylist = playlist
                                        deletePlaylist = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .contentMargins([.top, .bottom], 15)
                }
            }
            .navigationTitle(libraryItem.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("", selection: $playlistsSortOrder) {
                            ForEach(PlaylistSortOrder.allCases) { playlistSortOrder in
                                Text("Sort by \(playlistSortOrder.description)")
                                    .tag(playlistSortOrder)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addNewPlaylist = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Delete playlist?", isPresented: $deletePlaylist) {
                Button {
                    currentPlaylist = nil
                    deletePlaylist = false
                } label: {
                    Text("Cancel")
                }
                
                Button {
                    if let playlist = currentPlaylist {
                        libraryItem.playlists?.removeAll { $0 == playlist }
                        modelContext.delete(playlist)
                    }
                    
                    currentPlaylist = nil
                    deletePlaylist = false
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("Do you actually want to delete this playlist? No songs will be affected by this action")
            }
            .sheet(isPresented: $addNewPlaylist) {
                NewPlaylistView(libraryItem: libraryItem)
                    .presentationDetents([.medium])
            }
        }
    }
}
