//
//  AudioContentProvider.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 17/02/2022.
//

import Foundation


extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

protocol AudioProviderProtocol {
    func isFileExistingInLocalStorage(fileURL: String) -> Bool
    func downloadFileAndSaveToStorage(fileURL: String, completion: @escaping(_ success: Bool) -> Void)
    func getDestinationContentURLOfSavedSong(fileURL: String) -> URL?
}

class AudioContentProvider: AudioProviderProtocol{
    
    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func isFileExistingInLocalStorage(fileURL: String) -> Bool {
        
        if let audioURL = URL(string: fileURL), let componentToAdd = audioURL.valueOf("id"){
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(componentToAdd)
            print(destinationUrl)
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                return true
            }
        }
        
        return false
    }
    
    func downloadFileAndSaveToStorage(fileURL: String, completion: @escaping(_ success: Bool) -> Void) {
        if let audioURL = URL(string: fileURL), let componentToAdd = audioURL.valueOf("id") {
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(componentToAdd)
            URLSession.shared.downloadTask(with: audioURL, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    print("File moved to documents folder")
                    completion(true)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false)
                }
            }).resume()
        }
        
    }
    
    func getDestinationContentURLOfSavedSong(fileURL: String) -> URL? {
        if let audioURL = URL(string: fileURL), let componentToAdd = audioURL.valueOf("id"){
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(componentToAdd)
            return destinationUrl
        }
        
        return nil
    }
    
    
}
