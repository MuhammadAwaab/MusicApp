//
//  AudioPlayerManager.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 17/02/2022.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    static let shared = AudioPlayerManager()
    
    func playAudioWithContent(contentURL: URL) {
        self.stopPlayingAudio()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: contentURL)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopPlayingAudio(){
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
    
}
