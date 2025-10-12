import SwiftUI
import AVFoundation
import Observation

@Observable
final class AudioViewModel {
    var currentSong: Song?
    var isPlaying: Bool = false
    var isSeeking: Bool = false
    var currentDurationPosition: Double = 0
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    func play(song: Song) {
        stop()
        self.currentSong = song
        
        guard let url = song.url else {
            print("[Fatal error]: couldn't retrieve song's url")
            return
        }
        
        guard url.startAccessingSecurityScopedResource() else {
            print("[Fatal error]: couldn't access song")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            
            url.stopAccessingSecurityScopedResource()
            
            self.isPlaying = true
            startTimer()
        } catch {
            print("[Fatal error]: couldn't load audio:\n\n\(error)")
            self.isPlaying = false
        }
    }
    
    func seek(to time: Double) {
        player?.currentTime = time
    }
    
    func stop() {
        player?.stop()
        isPlaying = false
        stopTimer()
    }
    
    func toggle() {
        guard player != nil else {
            return
        }
        
        if isPlaying {
            player?.pause()
            isPlaying = false
            stopTimer()
        } else {
            player?.play()
            isPlaying = true
            startTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.updateProgress()
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateProgress() {
        guard let player = player, !isSeeking else {
            return
        }
        
        currentDurationPosition = player.currentTime
    }
}
