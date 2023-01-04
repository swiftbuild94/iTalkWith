//
//  AudioRecorder.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 19/04/2022.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
// import AVKit

/// Record Audio
///
/// Get Audio and delete recordings
final class AudioRecorder: ObservableObject {
    @Published var audios = [URL]()
    private var audioRecorder: AVAudioRecorder!
    private var audioSession: AVAudioSession!
    // var objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    deinit {
        self.stopRecording()
    }
    
    
    // MARK: - Allowed
    /// Is Allowed to Record
    /// - Returns: True if allowed
    func isAllowedToRecord() -> Bool {
        var isAllowed = false
        do {
            self.audioSession = AVAudioSession.sharedInstance()
            try self.audioSession.setCategory(.playAndRecord , mode: .spokenAudio)
            
            try self.audioSession.setActive(true)
            self.audioSession.requestRecordPermission() { allowed in
                isAllowed = allowed
                print("Audio -> Allowed to Record")
            }
            guard let availableInputs = self.audioSession.availableInputs else { return false }
            guard let builtInMicInput = availableInputs.first(where: {
                      $0.portType == .builtInMic
                  }) else { return false }
            try self.audioSession.setPreferredInput(builtInMicInput)
            print("Audio -> Mic Selected")
        } catch {
            let vmAlerts = AlertsManager()
            vmAlerts.showCancel = true
            vmAlerts.title = "Audio Recording"
            vmAlerts.message = "Audio recording not allowed please change settings in Settings"
            vmAlerts.defaultText = "Go to Settings"
            vmAlerts.okHandler = {
                print("Go to Settings")
            }
            vmAlerts.isAlert = true
            print("Audio -> Error not allowed to record: \(error)")
        }
        return isAllowed
    }
    
    
    // MARK: - Start Recording
    /// Record audio
    /// - Return: File Saved in documents
    func startRecording() {
        guard isAllowedToRecord() else { return }

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = Date().toString(dateFormat: "YY-MM-dd_HH-mm-ss-") + String(describing: UUID()) +  ".m4a"
        let audioFileURL = paths.appendingPathComponent(audioFileName)
        let recordSettings:[String:Any] = [AVFormatIDKey: kAudioFormatAppleLossless,
                                  AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                                  AVEncoderBitRateKey: 320000,
                                  AVNumberOfChannelsKey: 2,
                                  AVSampleRateKey: 44100.0 ] as [String : Any]
        print("Audio -> Start Record")
        do {
           audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: recordSettings)
            // let audioFormat = AVAudioFormat(settings: recordSettings)
            // audioRecorder = try AVAudioRecorder(url: audioFileURL, format: audioFormat!)
            // audioRecorder.isMeteringEnabled = true
            // audioRecorder.prepareToRecord()
            // audioRecorder.delegate = self
            // objectWillChange = delegate.publisher
            audioRecorder.record()
            let isRecording = audioRecorder.isRecording
            print("Audio -> Recording: \(isRecording)")
        } catch {
            print("Audio -> Error recording: \(error)")
        }
    }
    
    
    // MARK: - Stop Recording
    /// Stop the audio recording
    func stopRecording() {
        self.audioRecorder?.stop()
    }
    
    
    // MARK: - Get Audios
    /// Get the Audios
    /// - Return: An array with all the audio files in the document directory
    func getAudios() -> [URL]? {
        self.audios.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for audio in directoryContents {
                self.audios.append(audio)
            }
            return self.audios
        } catch {
            return nil
        }
    }
    

    // MARK: - Delete Recordings
    /// Delete Recording from the FileManager
    func deleteRecording(url : URL){
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
    }
}
