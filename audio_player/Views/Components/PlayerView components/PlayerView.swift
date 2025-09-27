import SwiftUI

struct PlayerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.title2)
                        .foregroundStyle(.foreground)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundStyle(.foreground)
                }
            }
            .padding()
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    PlayerView()
}
