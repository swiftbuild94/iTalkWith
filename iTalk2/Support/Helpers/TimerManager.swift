//
//  TimerManager.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 03/05/2022.
//

import SwiftUI

/// Returns a Timer with second Elapsed
final class TimerManager: ObservableObject {
    @Published var secondsElapsed = 0.0
    private var timer = Timer()
    
    func startTimer() {
        secondsElapsed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.secondsElapsed += 0.1
        })
    }
    
    func stopTimer() -> Double {
        timer.invalidate()
        return secondsElapsed
    }
}
