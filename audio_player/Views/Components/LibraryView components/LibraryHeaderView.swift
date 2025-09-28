import SwiftUI

struct LibraryHeaderView: View {
    @Binding var addsNewSection: Bool
    @Binding var sortOrder: LibrarySortOrder
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Library")
                .font(.largeTitle.bold())
            
            Spacer()
            
            Picker("Sort by", selection: $sortOrder) {
                ForEach(LibrarySortOrder.allCases) { sortOrderItem in
                    Text("Sort by \(sortOrderItem.description)")
                        .tag(sortOrderItem)
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: 200)
            
            Button {
                addsNewSection.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
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
    LibraryHeaderView(
        addsNewSection: .constant(false),
        sortOrder: .constant(LibrarySortOrder.title)
    )
}
