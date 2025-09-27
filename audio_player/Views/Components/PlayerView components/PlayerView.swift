import SwiftUI

struct PlayerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Text("Close")
            }
        }
    }
}

#Preview {
    PlayerView()
}
