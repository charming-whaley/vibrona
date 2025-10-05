import SwiftUI

struct SongItemView<Actions>: View where Actions: View {
    var song: Song
    var size: CGSize
    var actions: Actions
    
    init(song: Song, size: CGSize = .init(width: 40, height: 40), actions: @escaping () -> Actions) {
        self.song = song
        self.size = size
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
                .fill(Color("AppDarkGrayColor"))
        }
        .padding(.horizontal)
        .contentShape(.rect)
    }
    
    @ViewBuilder private func SongItemContentView() -> some View {
        HStack(spacing: 12) {
            EmptyCoverView(of: .init(width: size.width, height: size.height), with: .callout, of: size.height / 4, with: .black)
            SongItemInformationView()
        }
    }
    
    @ViewBuilder private func SongItemInformationView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(song.title)
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
}
