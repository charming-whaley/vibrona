import SwiftUI
import SwiftData

struct NewLibrarySectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = "Empty Category"
    @State private var systemImage: String = "music.pages.fill"
    @State private var libraryItemType: LibraryItemType = .songs
    
    private let covers: [String] = ["heart.fill", "music.note", "music.note.square.stack.fill", "rectangle.stack.fill"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                NewLibrarySectionHeaderView()
                NewLibrarySectionFooterView()
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Create Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        modelContext.insert(LibraryItem(
                            title: title,
                            systemImage: systemImage,
                            libraryItemType: libraryItemType,
                            isSystemItem: false
                        ))
                        
                        dismiss()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder private func NewLibrarySectionHeaderView() -> some View {
        Text("Title")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        TextField("Section title...", text: $title)
            .overlay(alignment: .bottom) {
                Divider()
                    .offset(y: 10)
            }
            .padding(.bottom, 20)
    }
    
    @ViewBuilder private func NewLibrarySectionFooterView() -> some View {
        Text("Cover & type")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
            HStack {
                ForEach(covers, id: \.self) { cover in
                    Image(systemName: cover)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(systemImage == cover ? .blue : .white)
                        .contentShape(.rect)
                        .onTapGesture {
                            systemImage = cover
                        }
                }
            }
            
            Spacer(minLength: 30)
            
            Picker("", selection: $libraryItemType) {
                ForEach(LibraryItemType.allCases) { type in
                    Text("\(type.description)")
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    NewLibrarySectionView()
}
