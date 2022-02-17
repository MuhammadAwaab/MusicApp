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
    let shouldBindForDownload: Bool
    var currentState: SongState
    private var currentAudioProvider: AudioProviderProtocol
    
    init(songToShow: SongData, audioProvider: AudioProviderProtocol = AudioContentProvider()) {
        self.displayData = songToShow
        self.currentAudioProvider = audioProvider
        if self.currentAudioProvider.isFileExistingInLocalStorage(fileURL: displayData.audioURL ?? "") {
            self.currentState = .paused
            shouldBindForDownload = false
        } else {
            self.currentState = .waitingForDownload
            shouldBindForDownload = true
        }
    }
    
    var updateOfDownloadAndSavedToDocuments:(() -> Void)?
    
    private func downloadCurrentAudio() {
        self.currentAudioProvider.downloadFileAndSaveToStorage(fileURL: displayData.audioURL ?? "") { success in
            if success {
                self.currentState = .paused
                self.updateOfDownloadAndSavedToDocuments?()
            }
        }
    }
    
    private func playCurrentSongAudio() {
        if let content = self.currentAudioProvider.getDestinationContentURLOfSavedSong(fileURL: displayData.audioURL ?? "") {
            AudioPlayerManager.shared.playAudioWithContent(contentURL: content)
        }
    }
    
    private func postNotificationForPausingOtherSongs() {
        NotificationCenter.default.post(name: NSNotification.Name("bandlab.stopPlayingSongs"), object: displayData.id)
    }
    
    func updateCurrentState() {
        switch currentState {
        case .playing:
            self.currentState = .paused
            AudioPlayerManager.shared.stopPlayingAudio()
        case .paused:
            self.currentState = .playing
            postNotificationForPausingOtherSongs()
            playCurrentSongAudio()
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
