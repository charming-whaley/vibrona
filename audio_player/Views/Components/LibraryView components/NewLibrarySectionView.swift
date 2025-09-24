import SwiftUI
import SwiftData

struct NewLibrarySectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = "helllllllllllo"
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .navigationTitle("Add new section")
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
                            systemImage: "music.pages.fill"
                        ))
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewLibrarySectionView()
}
