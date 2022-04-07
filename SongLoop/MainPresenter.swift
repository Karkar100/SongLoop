//
//  MainPresenter.swift
//  SongLoop
//
//  Created by Diana Princess on 06.04.2022.
//

import Foundation
import UIKit
import AVFoundation

protocol MainViewProtocol: class {
    
    func changePlayButton()
}

protocol MainPresenterProtocol: class, UIDocumentPickerDelegate {
    init(view: MainViewProtocol, router: RouterProtocol)
    func beginPlayback(urlArray: [URL], duration: Double)
    func startPlaying()
    func setDuration(value: Double)
}

class MainPresenter: NSObject, MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    required init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    var urlArray: [URL] = []
    let playerQueue = [AVPlayer(), AVPlayer()]
    var timeObserverToken: Any?
    var crossFadeDuration: Double?
    var currentPlayer: AVPlayer {
            return self.playingCopy ? self.playerQueue.last! : self.playerQueue.first!
        }
    var playingCopy: Bool = false
    
    func beginPlayback(urlArray: [URL], duration: Double) {
            self.currentPlayer.replaceCurrentItem(with: AVPlayerItem(url: urlArray.first!))
            
            if let currentItem = self.currentPlayer.currentItem {
                let copy = AVPlayerItem(url: urlArray.last!)
                self.playerQueue.last?.replaceCurrentItem(with: copy)
            }
        self.addVolumeRamps(with: duration)
        self.addPeriodicTimeObserver(for: self.currentPlayer)
        self.currentPlayer.play()
    }
    
    fileprivate func addVolumeRamps(with duration: Double) {
            for player in self.playerQueue {
                player.currentItem?.addFadeInOut(duration: duration)
            }
        }
    
    fileprivate func addPeriodicTimeObserver(for player: AVPlayer) {
        self.timeObserverToken = self.currentPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] (currentTime) in
            if let currentItem = self?.currentPlayer.currentItem, currentItem.status == .readyToPlay, let crossFadeDuration = self?.crossFadeDuration {
                let totalDuration = currentItem.asset.duration

                /**
                    Logic for Looping
                 */
                if (CMTimeCompare(currentTime, totalDuration - CMTimeMakeWithSeconds(crossFadeDuration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) > 0) {
                    self?.handleCrossFade()
                }
            }
        }
    }

    fileprivate func handleCrossFade() {
            self.removePeriodicTimeObserver(for: self.currentPlayer)
            self.playingCopy = !self.playingCopy
            self.addPeriodicTimeObserver(for: self.currentPlayer)
            self.currentPlayer.seek(to: .zero)
            self.currentPlayer.play()
        }

        fileprivate func removePeriodicTimeObserver(for player: AVPlayer) {
            if let timeObserverToken = timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
                self.timeObserverToken = nil
            }
        }
    
    func startPlaying(){
        beginPlayback(urlArray: urlArray, duration: crossFadeDuration ?? 5.0)
    }
    
    func setDuration(value: Double) {
        self.crossFadeDuration = value
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        urlArray.append(selectedFileURL)
        if urlArray.count == 2 {
            view?.changePlayButton()
        }
    }
}
