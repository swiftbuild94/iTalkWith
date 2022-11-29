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
    @Published var audioPlayer = AVAudioPlayer()
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    @Published var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    deinit {
        self.stopPlay()
    }
    
    
    // MARK: - Play Audio
    func playAudio(_ audio: URL) {
        print("=====Play Audio: \(audio)")
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
            print("Audio -> Allowed to Play")
        } catch {
            print("Playing over the device's speakers failed: \(error)")
            return
        }
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setMode(.spokenAudio)
            print("Audio -> Set Category")
        } catch {
            print("Error on Category")
            return
        }
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("Audio -> Activate session")
        } catch {
            print("Error on activate session: \(error)")
            return
        }
        do {
            try? (audio as NSURL).setResourceValue(.none, forKey: .fileProtectionKey)
            let data = try Data(contentsOf: audio)
            audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.m4a.rawValue)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            self.isPlaying = true
            print("Audio -> audio is playing")
        } catch {
            print("Error Playing: \(error)")
            return
        }
        print("Audio Played without errors")
    }
    

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    func stopPlay() {
        audioPlayer.stop()
        isPlaying = false
    }
}
