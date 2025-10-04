import SwiftUI

struct GlobalSearchFieldView: View {
    @Binding var searchQuery: String
    
    var body: some View {
        TextField(
            "",
            text: $searchQuery,
            prompt: Text("Explore")
                .foregroundStyle(.gray)
        )
        .foregroundStyle(.white)
        .padding(.vertical, 12)
        .padding(.leading)
        .padding(.trailing, 48)
        .background {
            RoundedRectangle(cornerRadius: 15.3)
                .fill(Color("AppDarkGrayColor"))
        }
        .overlay(alignment: .trailing) {
            if !searchQuery.isEmpty {
                Button {
                    searchQuery = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.gray)
                        .padding(.trailing)
                }
            }
        }
    }
}
