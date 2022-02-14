//
//  DataProvider.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import Foundation

protocol DataProviderProtocol {
    func fetchAndProvideData(completion: @escaping(_ serverData: BaseData?) -> Void)
}

class DataProvider: DataProviderProtocol {
    func fetchAndProvideData(completion: @escaping (BaseData?) -> Void) {
        let provider = ServiceProvider<SampleService>()
        
        provider.load(service: .fetchSampleProjectData) { result in
            switch result {
            case .success(let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(BaseData.self, from: data)
                    completion(responseModel)
                } catch  {
                    print("Serialization invalid error....")
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            case .empty:
                print("No data")
                completion(nil)
            }
        }
    }
    
}
