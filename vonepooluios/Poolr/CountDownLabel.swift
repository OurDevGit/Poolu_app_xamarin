//
//  CountDownLabel.swift
//  Poolr
//
//  Created by James Li on 2/19/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

@IBDesignable class CountDownLabel: UILabel {
    
    var timer = Timer()
    var seconds: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func runCountDown(intervalInSeconds: Int) {
        timer.invalidate()
        self.seconds = intervalInSeconds
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateTimer(){
        if seconds > 0 {
            seconds -= 1
            self.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    private func timeString(time:TimeInterval) -> String {
        let ti = NSInteger(time)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
    
 
    
 
}
