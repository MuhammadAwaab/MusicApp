//
//  OpenWeatherService.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import Foundation

let dataFetchUrl = "https://gist.githubusercontent.com/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"

enum SampleService {
    case fetchSampleProjectData
}


extension SampleService: Service {
    var baseURL: String {
        return "https://gist.githubusercontent.com"
    }
    
    var path: String {
        return "/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"
    }
    
    var parameters: [String: Any]? {
        // default params
        let params: [String: Any] = [:]
        
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
