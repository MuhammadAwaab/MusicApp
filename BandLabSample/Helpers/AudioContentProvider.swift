//
//  AudioContentProvider.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 17/02/2022.
//

import Foundation


protocol AudioProviderProtocol {
    func isFileExistingInLocalStorage(fileURL: String) -> Bool
    func downloadFileAndSaveToStorage(fileURL: String)
    func getDestinationContentURLOfSavedSong(fileURL: String) -> URL?
}

class AudioContentProvider: AudioProviderProtocol{
    
    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func isFileExistingInLocalStorage(fileURL: String) -> Bool {
        
        if let audioURL = URL(string: fileURL) {
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioURL.lastPathComponent)
            print(destinationUrl)
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                return true
            }
        }
        
        return false
    }
    
    func downloadFileAndSaveToStorage(fileURL: String) {
        if let audioURL = URL(string: fileURL) {
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioURL.lastPathComponent)
            URLSession.shared.downloadTask(with: audioURL, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
        
    }
    
    func getDestinationContentURLOfSavedSong(fileURL: String) -> URL? {
        if let audioURL = URL(string: fileURL) {
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioURL.lastPathComponent)
            return destinationUrl
        }
        
        return nil
    }
    
    
}
