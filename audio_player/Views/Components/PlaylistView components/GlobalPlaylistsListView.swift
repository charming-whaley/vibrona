import SwiftUI
import SwiftData

struct GlobalPlaylistsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var playlists: [Playlist]
    
    @State private var playlistsSortOrder: PlaylistSortOrder = .title
    @State private var searchQuery: String = ""
    @State private var currentPlaylist: Playlist?
    @State private var addNewPlaylist: Bool = false
    @State private var deletePlaylist: Bool = false
    
    var processedPlaylistsList: [Playlist] {
        var filteredPlaylistsList = [Playlist]()
        if searchQuery.isEmpty {
            filteredPlaylistsList = playlists
        } else {
            filteredPlaylistsList = playlists.filter { playlist in
                playlist.title.localizedStandardContains(searchQuery) || searchQuery.isEmpty
            }
        }
        
        var sortedPlaylistsList = [Playlist]()
        switch playlistsSortOrder {
        case .title:
            sortedPlaylistsList = filteredPlaylistsList.sorted { $0.title < $1.title }
        case .dateAdded:
            sortedPlaylistsList = filteredPlaylistsList.sorted { $0.dateAdded < $1.dateAdded }
        }
        return sortedPlaylistsList
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if playlists.isEmpty {
                    ContentUnavailableView("No Playlists...", systemImage: "music.note.list")
                } else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                            ForEach(processedPlaylistsList) { playlist in
                                NavigationLink {
                                    // Navigation to songs list
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
            .navigationTitle("Playlists")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, prompt: Text("Search playlists..."))
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
                NewPlaylistView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Playlist.self)
    preview.insert(Playlist.playlists)
    
    return GlobalPlaylistsListView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
