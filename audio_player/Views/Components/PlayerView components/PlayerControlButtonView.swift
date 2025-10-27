import SwiftUI

struct PlayerControlButtonView: View {
    let systemName: String
    var activeSystemName: String? = nil
    let isActive: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    private var currentSystemName: String {
        if isActive, let activeSystemName = activeSystemName {
            return activeSystemName
        }
        
        return systemName
    }
    
    private var color: Color {
        if isDisabled {
            return .gray
        }
        
        return isActive ? .blue : .white
    }
    
    var body: some View {
        Image(systemName: currentSystemName)
            .font(.title3)
            .foregroundStyle(color)
            .onTapGesture(perform: action)
            .disabled(isDisabled)
    }
}
