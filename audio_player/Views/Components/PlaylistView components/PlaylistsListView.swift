import SwiftUI
import SwiftData

struct PlaylistsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var playlists: [Playlist]
    
    @Bindable var libraryItem: LibraryItem
    @State private var searchQuery: String = ""
    @State private var newPlaylistName: String = "New playlist name"
    @State private var currentPlaylist: Playlist?
    @State private var playlistsSortOrder: PlaylistSortOrder = .title
    @State private var addNewPlaylist: Bool = false
    @State private var deletePlaylist: Bool = false
    @State private var renamePlaylist: Bool = false
    
    private let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]
    private var processedPlaylistsList: [Playlist] {
        return DataController.shared.retrieveProcessedPlaylistsList(of: libraryItem.playlists, by: searchQuery) {
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
                if processedPlaylistsList.isEmpty {
                    NoPlaylistsView()
                } else {
                    PlaylistsListContentView()
                }
            }
            .navigationTitle(libraryItem.title)
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
                Button("Cancel", action: resetDeleteAction)
                Button("Delete", action: removePlaylist)
            } message: {
                Text("Do you actually want to delete this playlist? No songs will be affected by this action")
            }
            .alert("Rename playlist", isPresented: $renamePlaylist) {
                TextField("Give new name", text: $newPlaylistName)
                Button("Cancel", action: resetRenameAction)
                Button("Rename", action: renamePlaylistAction)
            }
            .sheet(isPresented: $addNewPlaylist) {
                NewPlaylistView(libraryItem: libraryItem)
            }
        }
    }
    
    @ViewBuilder private func PlaylistsListContentView() -> some View {
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
    
    private func renamePlaylistAction() {
        currentPlaylist?.title = newPlaylistName
        
        do {
            try modelContext.save()
        } catch {
            print("[Fatal error]: couldn't rename the playlist:\n\n\(error)")
        }
        
        resetRenameAction()
    }
    
    private func resetRenameAction() {
        currentPlaylist = nil
        renamePlaylist = false
    }
    
    private func removePlaylist() {
        if let playlist = currentPlaylist {
            libraryItem.playlists?.removeAll { $0 == playlist }
            modelContext.delete(playlist)
        }
        
        resetDeleteAction()
    }
    
    private func resetDeleteAction() {
        currentPlaylist = nil
        deletePlaylist = false
    }
}
