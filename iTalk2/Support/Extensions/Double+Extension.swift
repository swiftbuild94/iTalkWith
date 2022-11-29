//
//  Double+Extension.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 22/05/2022.
//

import Foundation

extension Double {
    func showTimer() -> String {
        var secondsAudio = 0.0
        var minutesAudio = 0.0
        var hoursAudio = 0.0
        var hasHours = false
        var hasMinutes = false
        var timerString = ""
        if self >= 60 {
            minutesAudio = self / 60
            if self >= 60 {
                minutesAudio = self / 60
                secondsAudio = self - (minutesAudio * 60)
                hasMinutes = true
                if minutesAudio >= 60 {
                    hoursAudio = minutesAudio / 60
                    minutesAudio = minutesAudio - (hoursAudio * 60)
                    hasHours = true
                }
            }
        }
        if hoursAudio > 1 {
            timerString = String(Int(hoursAudio)) + ":"
        }
        if minutesAudio < 10 && hasHours {
            if minutesAudio == 0 {
                timerString += "00" + String(Int(minutesAudio))
            } else {
                timerString += "0" + String(Int(minutesAudio))
            }
        } else if minutesAudio > 1 {
            timerString += String(Int(minutesAudio))
        }
        if secondsAudio < 10 && hasMinutes {
            if secondsAudio > 0 {
                timerString += ":0" + String(Int(secondsAudio))
            }
        } else if hasMinutes {
            timerString += ":" + String(Int(secondsAudio))
        } else {
            timerString += String(Int(secondsAudio)) + "s"
        }
        return timerString
    }
}
