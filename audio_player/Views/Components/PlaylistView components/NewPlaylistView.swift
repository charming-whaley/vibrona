import SwiftUI
import SwiftData

struct NewPlaylistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title: String = "New Playlist"
    @State private var details: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Title")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Playlist name...", text: $title)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .offset(y: 10)
                    }
                    .padding(.bottom, 20)
                
                Text("Details (Optional)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Some inspirational words...", text: $details)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .offset(y: 10)
                    }
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Create Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        modelContext.insert(Playlist(title: title, details: details))
                        dismiss()
                    } label: {
                        Text("Create")
                    }
                }
            }
            .padding(.horizontal)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NewPlaylistView()
}
