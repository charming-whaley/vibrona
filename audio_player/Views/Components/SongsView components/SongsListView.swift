import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import UIKit
import AVFoundation

struct SongsListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var libraryItem: LibraryItem
    @State private var songsSortOrder: SongSortOrder = .title
    @State private var searchQuery: String = ""
    @State private var errorMessage: String = ""
    @State private var currentSong: Song?
    @State private var addSongs: Bool = false
    @State private var importsSongs: Bool = false
    
    private var processedSongsList: [Song] {
        return DataController.shared.retrieveProcessedSongsList(of: libraryItem.songs, by: searchQuery) {
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
                if processedSongsList.isEmpty {
                    NoSongsView()
                } else {
                    SongsListContentView()
                }
            }
            .navigationTitle(libraryItem.title)
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
                
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Button("Add from Library", action: { addSongs.toggle() })
                        Button("Import from device", action: { importsSongs.toggle() })
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $addSongs) {
                SongLibraryItemSelectionView(libraryItem: libraryItem)
            }
            .sheet(item: $currentSong) { song in
                SongPlaylistSelectionView(song: song)
            }
            .fileImporter(
                isPresented: $importsSongs,
                allowedContentTypes: [.mp3, .audio],
                allowsMultipleSelection: false
            ) { result in
                Task {
                    do {
                        try await DataController.shared.handleImportFiles(
                            from: result,
                            into: libraryItem,
                            using: modelContext
                        )
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func SongsListContentView() -> some View {
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
