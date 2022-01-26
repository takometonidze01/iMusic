//
//  CMTime + Extension.swift
//  iMusic
//
//  Created by CodergirlTM on 26.01.22.
//

import Foundation
import AVKit

extension CMTime {
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeForatString = String(format: "%02d:%02d", minutes, seconds)
        return timeForatString
    }
}
