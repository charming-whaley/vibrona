import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct PlaybackQueueView<PlayerControls>: View where PlayerControls: View {
    @Environment(AudioViewModel.self) var audioViewModel: AudioViewModel
    
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
            
            List {
                ForEach(playbackQueue) { song in
                    SongItemView(song: song, padding: 0) {
                        EmptyView()
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("AppDarkGrayColor"))
                            .padding(.vertical, 5)
                    )
                }
                .onMove(perform: audioViewModel.move)
            }
            .listStyle(.plain)
            .environment(\.editMode, .constant(.active))
            .scrollIndicators(.hidden)
            
            playerControls
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
