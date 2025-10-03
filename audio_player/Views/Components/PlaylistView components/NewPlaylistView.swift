import SwiftUI
import SwiftData
import PhotosUI

struct NewPlaylistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let libraryItem: LibraryItem?
    @State private var title: String = "New Playlist"
    @State private var details: String = ""
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var notCorrectCoverImage: Bool = false
    @State private var coverData: Data?
    
    init(libraryItem: LibraryItem? = nil) {
        self.libraryItem = libraryItem
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $photosPickerItem) {
                    Group {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                                .clipShape(.rect(cornerRadius: 15))
                        } else {
                            EmptyCoverView(of: .init(width: 300, height: 300), with: .system(size: 50))
                        }
                    }
                    .padding([.top, .bottom], 30)
                }
                
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
            .padding(.horizontal)
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
                        let playlist: Playlist
                        if let coverData = coverData {
                            playlist = Playlist(title: title, details: details, coverData: coverData)
                        } else {
                            playlist = Playlist(title: title, details: details)
                        }
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
            .onChange(of: photosPickerItem) { _, _ in
                Task {
                    if let photosPickerItem = photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            self.coverData = data
                            selectedImage = image
                        } else {
                            notCorrectCoverImage.toggle()
                        }
                    }
                    
                    photosPickerItem = nil
                }
            }
            .alert("Broken image", isPresented: $notCorrectCoverImage) {
                Button("Confirm") {
                    selectedImage = nil
                    photosPickerItem = nil
                    notCorrectCoverImage.toggle()
                }
            } message: {
                Text("It seems like your image is broken. Try to choose another one!")
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NewPlaylistView()
}
