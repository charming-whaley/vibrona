import SwiftUI
import Observation

@Observable
final class AudioViewModel {
    var currentSong: Song?
    var isPlaying: Bool = false
    var currentTime: Double = 0
}
