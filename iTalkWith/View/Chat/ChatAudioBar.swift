//
//  ChatAudioBar.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import SwiftUI

struct ChatAudioBar: View {
    @State private var audioIsRecording = false
    @ObservedObject var vmChat: ChatsVM
    // @ObservedObject var audioRecorder = AudioRecorder()
    // @ObservedObject var timerManager = TimerManager()
    
    var body: some View {
        if audioIsRecording == true {
            Button {
                print("Stop Recording")
                self.audioIsRecording = false
                AudioRecorder.shared.stopRecording()
                //self.audioRecorder.stopRecording()
                let _ = TimerManager.shared.stopTimer()
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
                Text(String(TimerManager.shared.secondsElapsed).prefix(4))
                    .dynamicTypeSize(.xxxLarge)
                Spacer()
                Button {
                    self.audioIsRecording = false
                    AudioRecorder.shared.stopRecording()
                    //self.audioRecorder.stopRecording()
                    vmChat.audioTimer = TimerManager.shared.stopTimer()
                    if AudioRecorder.shared.getAudios() != nil {
                        vmChat.handleSend(.audio)
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
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
                TimerManager.shared.startTimer()
                AudioRecorder.shared.startRecording()
                //self.audioRecorder.startRecording()
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
