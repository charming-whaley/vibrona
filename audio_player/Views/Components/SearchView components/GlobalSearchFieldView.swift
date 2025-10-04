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
        .padding(.leading, 40)
        .padding(.trailing, 48)
        .background {
            RoundedRectangle(cornerRadius: 15.3)
                .fill(Color("AppDarkGrayColor"))
        }
        .overlay(alignment: .leading) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .padding(.trailing)
                .padding(.horizontal, 12)
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
