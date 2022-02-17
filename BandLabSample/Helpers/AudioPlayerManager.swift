//
//  AudioPlayerManager.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 17/02/2022.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    
    var audioPlayer:AVAudioPlayer!
    static let shared = AudioPlayerManager()
    
    func playAudioWithContent(contentURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: contentURL)
            guard let player = audioPlayer else { return }
            player.prepareToPlay()
            player.play()
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
