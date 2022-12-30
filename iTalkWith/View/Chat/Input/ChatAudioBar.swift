//
//  ChatAudioBar.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import SwiftUI
import DSWaveformImage
import DSWaveformImageViews

struct ChatAudioBar: View {
    @State private var audioIsRecording = false
    @EnvironmentObject var vmChats: ChatsVM
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var timerManager = TimerManager()
    @State var waveformConfiguration: Waveform.Configuration = Waveform.Configuration(
        size: CGSize(width: 80, height: 30),
        backgroundColor: .gray,
        style: .filled(.blue),
        dampening: .none,
        position: .middle,
        scale: 1,
        verticalScalingFactor: 1,
        shouldAntialias: true
        )
    var samples: [Float] = []
    
    var body: some View {
        if audioIsRecording == true {
            Button {
                print("Stop Recording")
                self.audioIsRecording = false
                //AudioRecorder.shared.stopRecording()
                self.audioRecorder.stopRecording()
                let _ = self.timerManager.stopTimer()
            } label: {
                Image(systemName: "trash.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipped()
                    .foregroundColor(.primary)
                    .padding(.bottom, 40)
                    .padding(.leading, 40)
                Spacer()
                
                WaveformLiveCanvas(samples: samples, configuration: waveformConfiguration)
                                .padding(.vertical, 2)
                
                Text(String(self.timerManager.secondsElapsed).prefix(4))
                    .dynamicTypeSize(.xxxLarge)
                Spacer()
                Button {
                    self.audioIsRecording = false
                    //AudioRecorder.shared.stopRecording()
                    self.audioRecorder.stopRecording()
                    vmChats.audioTimer = self.timerManager.stopTimer()
                    if self.audioRecorder.getAudios() != nil {
                        vmChats.handleSend(.audio)
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.blue)
                        .padding(.bottom, 40)
                        .padding()
                }
            }
        } else {
            Button {
                print("Start Recording")
                self.audioIsRecording = true
                self.timerManager.startTimer()
                //AudioRecorder.shared.startRecording()
                self.audioRecorder.startRecording()
            } label: {
                Image(systemName: "mic.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .foregroundColor(.red)
                    .padding(.bottom, 40)
            }
        }
    }
}


struct ChatAudioBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatAudioBar()
//            .environmentObject(ChatsVM())
    }
}
