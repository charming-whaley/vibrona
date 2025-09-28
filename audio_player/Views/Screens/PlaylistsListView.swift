import SwiftUI
import SwiftData

struct PlaylistsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var playlists: [Playlist]
    
    @State private var currentPlaylist: Playlist?
    @State private var addNewPlaylist: Bool = false
    @State private var deletePlaylist: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                    ForEach(playlists) { playlist in
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
            .navigationTitle("Playlists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
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
    
    return PlaylistsListView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
