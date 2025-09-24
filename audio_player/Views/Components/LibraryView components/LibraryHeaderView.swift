import SwiftUI

struct LibraryHeaderView: View {
    @Binding var addsNewSection: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Library")
                .font(.largeTitle.bold())
            
            Spacer()
            
            Button {
                addsNewSection.toggle()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .padding(8)
                    .background {
                        Circle()
                    }
            }
        }
        .padding()
    }
}

#Preview {
    LibraryHeaderView(addsNewSection: .constant(false))
}
