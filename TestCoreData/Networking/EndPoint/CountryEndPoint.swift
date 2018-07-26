//
//  CountryEndPoint.swift
//  SwiftNetworkApp
//
//  Created by Kumar Mishra, R. F. on 6/12/18.
//  Copyright © 2018 Kumar Mishra, R. F. All rights reserved.
//

import Foundation


public enum CountryApi {
    case country
    
}

enum NetworkEnvironment {
    case qa
    case production
    case staging
}


extension CountryApi : EndPointType {
    
    var environmentBaseURL : String {
        switch CountryManager.environment {
        case .production: return "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        case .qa: return ""
        case .staging: return ""
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .country:
            return "/country/search?text=in"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
            
        case .country:
            return .request
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
