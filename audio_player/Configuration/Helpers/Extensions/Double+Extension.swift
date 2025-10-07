import Foundation

extension Double {
    var asTime: String {
        guard self >= 0 else {
            return "0:00"
        }
        
        if Int(self) / 3600 > 0 {
            return String(format: "%02d:%02d:%02d", Int(self) / 3600, (Int(self) % 3600) / 60, Int(self) % 60)
        }
        
        return String(format: "%02d:%02d", (Int(self) % 3600) / 60, Int(self) % 60)
    }
}
