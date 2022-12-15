//
//  AudioPlayer.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import AVKit

/// Play Audio
final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioSession = AVAudioSession.sharedInstance()
    private var audioPlayer = AVAudioPlayer()
    @Published var isPlaying = false

    /// On denit Stop Play
    deinit {
        self.stopPlay()
    }
    
    /// Setup the audio session
    private func setAudioSession() {
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
            print("Audio -> Allowed to Play")
        } catch {
            print("Playing over the device's speakers failed: \(error)")
            return
        }
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setMode(.default)
            print("Audio -> Set Category")
        } catch {
            print("Error on Category")
            return
        }
        do {
            try audioSession.setActive(true)
            print("Audio -> Activate session")
        } catch {
            print("Error on activate session: \(error)")
            return
        }
    }
    
    /// Plays the audio
    /// - Parameters:
    /// audio: URL the local url of the audio
    func playAudio(_ audio: URL) {
        print("=====Play Audio: \(audio)")
        setAudioSession()
        guard ((try? (audio as NSURL).setResourceValue(.none, forKey: .fileProtectionKey)) != nil) else { return }
        guard let data = try? Data(contentsOf: audio) else { return }
        do {
            self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.m4a.rawValue)
            print("Audio -> audio is playing")
        } catch {
            print("Error Playing: \(error)")
            return
        }
        audioPlayer.prepareToPlay()
        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        audioPlayer.isMeteringEnabled = true
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        DispatchQueue.main.async {
            self.isPlaying = true
        }
        print("Audio Played without errors")
    }
    
    /// If audio stop playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    ///Stop the play only if the audio has finished playing
    func stopPlay() {
        audioPlayer.stop()
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
}
