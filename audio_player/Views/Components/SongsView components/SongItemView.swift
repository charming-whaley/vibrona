import SwiftUI

struct SongItemView<Actions, Style>: View where Actions: View, Style: ShapeStyle {
    @Environment(AudioViewModel.self) var audioViewModel
    
    var song: Song
    var size: CGSize
    var padding: CGFloat
    var actions: Actions
    var style: Style
    
    init(
        song: Song,
        size: CGSize = .init(width: 40, height: 40),
        padding: CGFloat = 16,
        style: Style = Color("AppDarkGrayColor"),
        actions: @escaping () -> Actions
    ) {
        self.song = song
        self.size = size
        self.padding = padding
        self.style = style
        self.actions = actions()
    }
    
    var body: some View {
        HStack(spacing: 15) {
            SongItemContentView()
            Spacer()
            actions
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(style)
        }
        .padding(.horizontal, padding)
        .contentShape(.rect)
    }
    
    @ViewBuilder private func SongItemContentView() -> some View {
        HStack(spacing: 12) {
            Group {
                if let cover = song.cover {
                    Image(uiImage: cover)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(.rect(cornerRadius: 15))
                } else {
                    EmptyCoverView(of: .init(width: size.width, height: size.height), with: .callout, of: size.height / 4, with: .black)
                }
            }
            .overlay(alignment: .bottom) {
                if let currentSong = audioViewModel.currentSong, currentSong == song, audioViewModel.isPlaying {
                    AnimatedEqualizerBarsView()
                        .frame(width: 25, height: 25)
                }
            }
            
            SongItemInformationView()
        }
    }
    
    @ViewBuilder private func SongItemInformationView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(song.title == "No title provided" ? song.fileName?.removeFileExtension ?? "Weird file name" : song.title)
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("\(song.artist)")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    SongItemView(song: .init(title: "Welcome to New York", artist: "Taylor Swift", filePath: "")) {
        VStack {  }
    }
    .preferredColorScheme(.dark)
    .environment(AudioViewModel())
}
