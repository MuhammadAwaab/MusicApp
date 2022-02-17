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
    func downloadFileAndSaveToStorage(fileURL: String)
    func getDestinationContentURLOfSavedSong(fileURL: String) -> URL?
    
    var downloadCompletionSuccess:((_ success: Bool) -> Void)? { get set }
    var showDownloadProgressOfCurrentContent:((_ percentage: Double) -> Void)? { get set }
}

class AudioContentProvider: NSObject, ObservableObject, AudioProviderProtocol{
    
    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var currentURLForDownloadFile: URL?
    
    var downloadCompletionSuccess:((_ success: Bool) -> Void)?
    var showDownloadProgressOfCurrentContent:((_ percentage: Double) -> Void)?
    
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
    
    
    private func updateAudioInFileManagerWith(component: String, audioURL: URL) {
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(component)
        URLSession.shared.downloadTask(with: audioURL, completionHandler: { (location, response, error) -> Void in
            guard let location = location, error == nil else { return }
            do {
                try FileManager.default.removeItem(at: destinationUrl)
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                print("File moved to documents folder")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }).resume()
    }
    
    func downloadFileAndSaveToStorage(fileURL: String) {
        if let audioURL = URL(string: fileURL){
            self.currentURLForDownloadFile = audioURL
            let configuration = URLSessionConfiguration.default
            let operationQueue = OperationQueue()
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            
            let downloadTask = session.downloadTask(with: audioURL)
            downloadTask.resume()
            
        }
        
    }
    
    func getDestinationContentURLOfSavedSong(fileURL: String) -> URL? {
        if let audioURL = URL(string: fileURL), let componentToAdd = audioURL.valueOf("id"){
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(componentToAdd)
            self.updateAudioInFileManagerWith(component: componentToAdd, audioURL: audioURL)
            return destinationUrl
        }
        
        return nil
    }
    
}


extension AudioContentProvider: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten _: Int64, totalBytesExpectedToWrite _: Int64) {
        self.showDownloadProgressOfCurrentContent?(downloadTask.progress.fractionCompleted)
    }
    
    func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let audioURL = currentURLForDownloadFile, let componentToAdd = audioURL.valueOf("id") {
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(componentToAdd)
            do {
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                print("File moved to documents folder")
                self.downloadCompletionSuccess?(true)
            } catch let error as NSError {
                print(error.localizedDescription)
                self.downloadCompletionSuccess?(false)
            }
        }
    }
    
    func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let _ = error {
            self.downloadCompletionSuccess?(false)
        }
    }
}
