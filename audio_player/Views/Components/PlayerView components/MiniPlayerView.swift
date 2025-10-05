import SwiftUI

struct MiniPlayerView: View {
    let size: CGSize = .init(width: 32, height: 32)
    
    var body: some View {
        HStack(spacing: 15) {
            MiniPlayerLHSView()
            Spacer()
            MiniPlayerRHSView()
        }
        .padding(.horizontal)
        .contentShape(.rect)
    }
    
    @ViewBuilder private func MiniPlayerLHSView() -> some View {
        HStack(spacing: 12) {
            EmptyCoverView(of: size, with: .caption, of: size.width / 4, with: Color("AppDarkGrayColor"))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Trash title")
                    .font(.callout)
                
                Text("Trash artist")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    @ViewBuilder private func MiniPlayerRHSView() -> some View {
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
}

#Preview {
    MiniPlayerView()
}
