import SwiftUI
import SwiftData

struct NewPlaylistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let libraryItem: LibraryItem?
    @State private var title: String = "New Playlist"
    @State private var details: String = ""
    
    init(libraryItem: LibraryItem? = nil) {
        self.libraryItem = libraryItem
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Title")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Playlist name...", text: $title)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .offset(y: 10)
                    }
                    .padding(.bottom, 20)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Create Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let playlist = Playlist(title: title, details: details)
                        modelContext.insert(playlist)
                        
                        if let libraryItem = libraryItem {
                            if libraryItem.playlists == nil {
                                libraryItem.playlists = [playlist]
                            } else {
                                libraryItem.playlists?.append(playlist)
                            }
                        }
                        
                        do {
                            try modelContext.save()
                        } catch {
                            print("[Fatal error]: couldn't resolve the operation. The reason is\n\(error)")
                        }
                        
                        dismiss()
                    } label: {
                        Text("Create")
                    }
                }
            }
            .padding(.horizontal)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NewPlaylistView()
}
