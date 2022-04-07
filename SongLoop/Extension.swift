//
//  Extension.swift
//  SongLoop
//
//  Created by Diana Princess on 06.04.2022.
//

import Foundation
import AVFoundation

extension AVPlayerItem {
    func addFadeInOut(duration: TimeInterval = 1.0) {
        let params = AVMutableAudioMixInputParameters(track: self.asset.tracks.first! as AVAssetTrack)
        let timeRange = CMTimeRangeMake(start: CMTimeMakeWithSeconds(0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), duration: CMTimeMakeWithSeconds(duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
         let timeRangeTowardsEnd = CMTimeRangeMake(start: CMTimeMakeWithSeconds(CMTimeGetSeconds(self.asset.duration) - duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), duration: CMTimeMakeWithSeconds(duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        params.setVolumeRamp(fromStartVolume: 0, toEndVolume: 1, timeRange: timeRange)
        params.setVolumeRamp(fromStartVolume: 1, toEndVolume: 0, timeRange: timeRangeTowardsEnd)
        let mix = AVMutableAudioMix()
        mix.inputParameters = [params]
        self.audioMix = mix
    }
}
