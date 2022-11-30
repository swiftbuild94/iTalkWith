//
//  ChatAudioBar.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import SwiftUI

struct ChatAudioBar: View {
    @State private var audioIsRecording = false
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject var vmChat: ChatsVM
    
    var body: some View {
        if audioIsRecording == true {
            Button {
                print("Stop Recording")
                self.audioIsRecording = false
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
                Text(String(timerManager.secondsElapsed).prefix(4))
                    .dynamicTypeSize(.xxxLarge)
                Spacer()
                Button {
                    self.audioIsRecording = false
                    self.audioRecorder.stopRecording()
                    vmChat.audioTimer = self.timerManager.stopTimer()
                    if self.audioRecorder.getAudios() != nil {
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
                self.timerManager.startTimer()
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
