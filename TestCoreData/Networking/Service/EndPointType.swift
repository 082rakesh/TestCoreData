//
//  EndPointType.swift
//  SwiftNetworkApp
//
//  Created by Kumar Mishra, R. F. on 6/12/18.
//  Copyright © 2018 Kumar Mishra, R. F. All rights reserved.
//

import Foundation


protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    
}
