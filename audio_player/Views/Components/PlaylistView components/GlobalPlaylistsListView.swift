import SwiftUI
import SwiftData

struct GlobalPlaylistsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var playlists: [Playlist]
    
    @State private var searchQuery: String = ""
    @State private var newPlaylistName: String = "New playlist name"
    @State private var currentPlaylist: Playlist?
    @State private var playlistsSortOrder: PlaylistSortOrder = .title
    @State private var addNewPlaylist: Bool = false
    @State private var deletePlaylist: Bool = false
    @State private var renamePlaylist: Bool = false
    
    private let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]
    private var processedPlaylistsList: [Playlist] {
        return DataController.shared.retrieveProcessedPlaylistsList(of: playlists, by: searchQuery) {
            switch playlistsSortOrder {
            case .title:
                $0.title < $1.title
            case .dateAdded:
                $0.dateAdded < $1.dateAdded
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if playlists.isEmpty {
                    NoPlaylistsView()
                } else {
                    GlobalPlaylistsListContentView()
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
            .alert("Rename playlist", isPresented: $renamePlaylist) {
                TextField("Give new name", text: $newPlaylistName)
                
                Button("Cancel") {
                    currentPlaylist = nil
                    renamePlaylist = false
                }
                
                Button("Rename") {
                    currentPlaylist?.title = newPlaylistName
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("[Fatal error]: couldn't rename the playlist:\n\n\(error)")
                    }
                    
                    currentPlaylist = nil
                    renamePlaylist = false
                }
            }
            .sheet(isPresented: $addNewPlaylist) {
                NewPlaylistView()
            }
        }
    }
    
    @ViewBuilder private func GlobalPlaylistsListContentView() -> some View {
        PlaylistsCollectionView(columns: columns, edges: [.top, .bottom]) {
            ForEach(processedPlaylistsList) { playlist in
                NavigationLink {
                    PlaylistView(playlist: playlist)
                } label: {
                    MiniPlaylistItemView(playlist: playlist)
                }
                .contextMenu {
                    Button {
                        currentPlaylist = playlist
                        renamePlaylist = true
                    } label: {
                        Label("Rename...", systemImage: "rectangle.and.pencil.and.ellipsis")
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
    }
}

#Preview {
    let preview = PreviewContainer(Playlist.self)
    preview.insert(Playlist.playlists)
    
    return GlobalPlaylistsListView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
