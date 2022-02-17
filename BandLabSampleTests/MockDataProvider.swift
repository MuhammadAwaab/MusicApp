//
//  MockDataProvider.swift
//  BandLabSampleTests
//
//  Created by Muhammad Oneeb on 17/02/2022.
//

import Foundation

class MockDataProvider: DataProviderProtocol {
    func fetchAndProvideData(completion: @escaping (BaseData?) -> Void) {
        if let path = Bundle.main.path(forResource: "SampleData", ofType: "json") {
                  do {
                      let fileUrl = URL(fileURLWithPath: path)
                      // Getting data from JSON file using the file URL
                      let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                      let jsonDecoder = JSONDecoder()
                      let responseModel = try jsonDecoder.decode(BaseData.self, from: data)
                      completion(responseModel)
                  } catch {
                      // Handle error here
                      print("error parsing local json...")
                      completion(nil)
                  }
              }
    }
    
    
}
