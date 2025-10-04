import SwiftUI
import SwiftData
import PhotosUI

struct PlaylistView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var addsSongsToPlaylist: Bool = false
    @State private var songsSortOrder: SongSortOrder = .title
    @State private var notCorrectCoverImage: Bool = false
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var renamePlaylist: Bool = false
    @State private var searchQuery: String = ""
    @State private var topInset: CGFloat = 0
    @State private var scrollOffsetY: CGFloat = 0
    @State private var newPlaylistTitle: String = "New playlist name"
    
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
                PhotosPicker(selection: $photosPickerItem) {
                    Group {
                        if let coverData = playlist.coverData {
                            Image(uiImage: UIImage(data: coverData)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                                .clipShape(.rect(cornerRadius: 12))
                        } else {
                            EmptyCoverView(of: .init(width: 300, height: 300), with: .system(size: 50), of: 12)
                        }
                    }
                    .padding(16)
                    .background(PlaylistBackgroundFadeView(
                        image: playlist.cover,
                        topInset: $topInset,
                        scrollOffsetY: $scrollOffsetY
                    ))
                    .zIndex(-1)
                }
                
                Text(playlist.title)
                    .font(.title3.bold())
                    .padding(.bottom, 12)
                    .contentShape(.rect)
                    .onTapGesture {
                        renamePlaylist.toggle()
                    }
                
                Divider()
                    .padding(.horizontal)
                
                Button {
                    addsSongsToPlaylist.toggle()
                } label: {
                    AddSongToPlaylistButtonView()
                }
                
                if processedSongsList.isEmpty {
                    NoSongsView()
                        .padding(.vertical, 40)
                } else {
                    LazyVStack {
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
                                        playlist.songs.removeAll(where: { $0.id == song.id })
                                        
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            print("[Fatal error]: couldn't resolve the operation:\n\n\(error)")
                                        }
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
                    .padding(.bottom, 20)
                }
            }
            .onScrollGeometryChange(for: ScrollGeometry.self, of: {
                $0
            }, action: { oldValue, newValue in
                topInset = newValue.contentInsets.top + 100
                scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
            })
            .onChange(of: photosPickerItem) { _, _ in
                Task {
                    if let photosPickerItem = photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let _ = UIImage(data: data) {
                            playlist.coverData = data
                        } else {
                            notCorrectCoverImage.toggle()
                        }
                    }
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("[Fatal error]: couldn't save the context:\n\n\(error)")
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
            .alert("Broken image", isPresented: $notCorrectCoverImage) {
                Button("Confirm") {
                    photosPickerItem = nil
                    notCorrectCoverImage.toggle()
                }
            } message: {
                Text("It seems like your image is broken. Try to choose another one!")
            }
            .alert("Rename playlist", isPresented: $renamePlaylist) {
                TextField("Enter a new name...", text: $newPlaylistTitle)
                
                HStack {
                    Button("Cancel") {
                        renamePlaylist.toggle()
                        newPlaylistTitle = "New playlist name"
                    }
                    
                    Button("Rename") {
                        playlist.title = newPlaylistTitle
                        do {
                            try modelContext.save()
                        } catch {
                            print("[Fatal error]: couldn't resolve the operation:\n\n\(error)")
                        }
                    }
                }
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
