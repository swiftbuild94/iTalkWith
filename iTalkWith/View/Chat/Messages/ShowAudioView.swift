//
//  ShowAudioView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 23/12/2022.
//

import SwiftUI
import DSWaveformImage
import DSWaveformImageViews

/// Show audio in buble and enable play
struct ShowAudioView: View {
    @EnvironmentObject var vmChats: ChatsVM
    @ObservedObject var vmAudio = AudioPlayer()
    @ObservedObject var timerManager = TimerManager()
    let message: Chat
    
    @State var waveformConfiguration: Waveform.Configuration = Waveform.Configuration(
        size: CGSize(width: 80, height: 280),
        backgroundColor: .white,
        style: .filled(.blue),
        dampening: .none,
        position: .middle,
        scale: 1,
        verticalScalingFactor: 1,
        shouldAntialias: true
        )
    
    var body: some View {
        if vmAudio.isPlaying {
            Button {
                DispatchQueue.global(qos: .userInteractive).async {
                    vmAudio.stopPlay()
                }
                let _ = timerManager.stopTimer()
            } label: {
//                if vm.audioURL != nil {
//                    WaveformView(audioURL: vm.audioURL!, configuration: waveformConfiguration, priority: .medium)
//                }
                Image(systemName: "stop.fill").dynamicTypeSize(.xxxLarge)
                if message.audioLocalURL != nil {
                    //Text(String(describing: message.audioLocalURL!))
                    WaveformView(audioURL: message.audioLocalURL!, configuration: waveformConfiguration, priority: .background)
                }
                Text(String(format: "%.1f", timerManager.secondsElapsed))
            }
        } else {
            Button {
                timerManager.startTimer()
                //DispatchQueue.global(qos: .userInteractive).async {
                    if let audio = message.audio {
                        if let audioDownloaded = vmChats.downloadAudio(audio) {
                            vmAudio.playAudio(audioDownloaded)
                        }
                    }
                //}
            } label: {
                Image(systemName: "play.fill").dynamicTypeSize(.xxxLarge)
                if message.audioLocalURL != nil {
                    //Text(String(describing: message.audioLocalURL!))
                    WaveformView(audioURL: message.audioLocalURL!, configuration: waveformConfiguration, priority: .background)
                }
//                if let audio = message.audio {
//                    if let audioDownloaded = vmChats.downloadAudio(audio) {
//                        Text(String(describing: audioDownloaded))
//
//                    }
//                }
                if let audioTimer = message.audioTimer {
                    let trimedAudio = String(audioTimer).prefix(2)
                    Text(trimedAudio)
                }
            }
        }
    }
}
let showAudioChat = Chat(id: "", fromId: "", toId: "", text: "text", photo: nil, audio: nil, audioTimer: nil, audioLocalURL: nil, timestamp: Date() )

struct ShowAudioView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAudioView(message: showAudioChat)
            .environmentObject(ChatsVM())
    }
}
