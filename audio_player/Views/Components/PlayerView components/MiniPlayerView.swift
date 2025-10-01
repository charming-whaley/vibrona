import SwiftUI

struct MiniPlayerView: View {
    let size: CGSize = .init(width: 32, height: 32)
    
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 12) {
                Rectangle()
                    .fill(Color("AppDarkGrayColor"))
                    .clipShape(.rect(cornerRadius: size.width / 4))
                    .frame(width: size.width, height: size.height)
                    .overlay(alignment: .center) {
                        Image(systemName: "music.note")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Trash title")
                        .font(.callout)
                    
                    Text("Trash artist")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "play.fill")
                    .contentShape(.rect)
                    .foregroundStyle(.foreground)
            }
            .padding(.trailing, 10)
            
            Button {
                
            } label: {
                Image(systemName: "forward.fill")
                    .contentShape(.rect)
                    .foregroundStyle(.foreground)
            }
        }
        .padding(.horizontal)
        .contentShape(.rect)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .bottomTrailing)
        MiniPlayerView()
    }
}
