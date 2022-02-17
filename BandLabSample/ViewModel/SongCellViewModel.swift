//
//  SongCellViewModel.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import Foundation
import UIKit


enum SongState {
    case waitingForDownload
    case downloading
    case playing
    case paused
    
    var buttonImage: UIImage? {
        switch self {
        case .waitingForDownload:
            return #imageLiteral(resourceName: "download")
        case .downloading:
            return nil
        case .playing:
            return #imageLiteral(resourceName: "pause.pdf")
        case .paused:
            return #imageLiteral(resourceName: "play.pdf")
        }
    }
    
    var buttonInteractionEnabled: Bool {
        switch self {
        case .waitingForDownload, .paused, .playing:
            return true
        case .downloading:
            return false
        }
    }
    
}


class SongCellViewModel {
    let displayData: SongData
    var currentState: SongState
    private var currentAudioProvider: AudioProviderProtocol
    
    init(songToShow: SongData, audioProvider: AudioProviderProtocol = AudioContentProvider()) {
        self.displayData = songToShow
        self.currentAudioProvider = audioProvider
        if self.currentAudioProvider.isFileExistingInLocalStorage(fileURL: displayData.audioURL ?? "") {
            self.currentState = .playing
        } else {
            self.currentState = .waitingForDownload
        }
    }
    
    
    private func downloadCurrentAudio() {
        self.currentAudioProvider.downloadFileAndSaveToStorage(fileURL: displayData.audioURL ?? "")
    }
    
    private func playCurrentSongAudio() {
        if let content = self.currentAudioProvider.getDestinationContentURLOfSavedSong(fileURL: displayData.audioURL ?? "") {
            AudioPlayerManager.shared.playAudioWithContent(contentURL: content)
        }
        
    }
    
    func updateCurrentState() {
        switch currentState {
        case .playing:
            self.currentState = .paused
            playCurrentSongAudio()
        case .paused:
            self.currentState = .playing
            AudioPlayerManager.shared.stopPlayingAudio()
        case .waitingForDownload:
            downloadCurrentAudio()
            self.currentState = .downloading
        case .downloading:
            self.currentState = .downloading
        }
    }
    
    func pauseSongIfPlaying() {
        if currentState == .playing {
            currentState = .paused
        }
    }
}
