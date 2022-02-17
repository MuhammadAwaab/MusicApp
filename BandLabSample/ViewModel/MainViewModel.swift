//
//  MainViewModel.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import Foundation

protocol MainViewModelProtocol {
    func fetchParsedDataForDisplay()
    func getCellViewModel(at indexPath: IndexPath) -> SongCellViewModel
}

class MainViewModel: MainViewModelProtocol {
   
    private var currentProvider: DataProviderProtocol
    private let cellIdentifier = "SongCell"
    
    var cellViewModelsArray: [SongCellViewModel] = [] {
        didSet{
            self.updateView?()
        }
    }
    
    var updateView:(() -> Void)?
    var showErrorAlertView:(() -> Void)?
    
    init(provider: DataProviderProtocol = DataProvider()){
        self.currentProvider = provider
    }
    
    
    func fetchParsedDataForDisplay() {
        self.currentProvider.fetchAndProvideData { data in
            if let parsedData = data, let songs = parsedData.songData, songs.count > 0 {
                self.updateCellModelViewsWith(parsedData: songs)
            } else {
                self.showErrorAlertView?()
            }
        }
    }
    
    func getCellIdentifier() -> String {
        return self.cellIdentifier
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> SongCellViewModel {
            return cellViewModelsArray[indexPath.row]
        }
    
    func stopPlayingSongs() {
        for cellViewModel in cellViewModelsArray {
            cellViewModel.pauseSongIfPlaying()
        }
    }
    
    private func updateCellModelViewsWith(parsedData: [SongData]) {
        var arrayForModels: [SongCellViewModel] = []
        for song in parsedData {
            arrayForModels.append(SongCellViewModel(songToShow: song))
        }
        cellViewModelsArray = arrayForModels
    }
   
    
}
