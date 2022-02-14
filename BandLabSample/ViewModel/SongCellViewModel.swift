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
    
    init(songToShow: SongData) {
        self.displayData = songToShow
        self.currentState = .waitingForDownload
    }
    
    func updateCurrentState() {
        switch currentState {
        case .playing:
            self.currentState = .paused
        case .paused:
            self.currentState = .playing
        case .waitingForDownload:
            self.currentState = .downloading
        case .downloading:
            self.currentState = .downloading
        }
    }
    
}
