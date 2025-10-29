import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct PlaybackQueueView<PlayerControls>: View where PlayerControls: View {
    @Environment(AudioViewModel.self) var audioViewModel: AudioViewModel
    
    @State private var draggedSong: Song?
    var playerControls: PlayerControls
    
    var playbackQueue: [Song] {
        if audioViewModel.isShuffled {
            return audioViewModel.playbackQueueAfterShuffling
        }
        
        return audioViewModel.playbackQueueBeforeShuffling
    }
    
    init(playerControls: @escaping () -> PlayerControls) {
        self.playerControls = playerControls()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 0) {
                Text("Playing Next")
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.top, 12)
            
            SongsCollectionView(removeScrollIndicators: true, padding: 0) {
                ForEach(playbackQueue) { song in
                    SongItemView(song: song, padding: 0) {
                        Image(systemName: "line.3.horizontal")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .contentShape(.rect)
                    }
                    .onDrag {
                        draggedSong = song
                        return NSItemProvider(object: song.id.uuidString as NSString)
                    }
                    .onDrop(of: [UTType.text], delegate: SongItemDropDelegate(
                        song: song,
                        draggedSong: $draggedSong,
                        audioViewModel: audioViewModel
                    ))
                }
            }
            
            playerControls
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SongItemDropDelegate: DropDelegate {
    let song: Song
    @Binding var draggedSong: Song?
    let audioViewModel: AudioViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedSong = draggedSong else {
            return false
        }
        
        let source = audioViewModel.isShuffled ? audioViewModel.playbackQueueAfterShuffling : audioViewModel.playbackQueueBeforeShuffling
        guard
            let fromPosition = source.firstIndex(of: draggedSong),
            let toPosition = source.firstIndex(of: song)
        else {
            return false
        }
        
        let destination = toPosition > fromPosition ? toPosition + 1 : toPosition
        audioViewModel.move(from: IndexSet(integer: fromPosition), to: destination)
        
        self.draggedSong = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return PlaybackQueueView() {
        VStack {}
    }
    .preferredColorScheme(.dark)
    .modelContainer(preview.container)
    .environment(AudioViewModel())
}
