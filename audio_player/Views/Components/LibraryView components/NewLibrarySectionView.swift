import SwiftUI
import SwiftData

struct NewLibrarySectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = "Empty Category"
    @State private var systemImage: String = "music.pages.fill"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Text("Title")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Section title...", text: $title)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .offset(y: 10)
                    }
            }
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
                            systemImage: "music.pages.fill",
                            libraryItemType: .songs,
                            isSystemItem: false
                        ))
                        
                        dismiss()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NewLibrarySectionView()
}
