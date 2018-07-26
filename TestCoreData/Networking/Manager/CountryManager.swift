//
//  CountryManager.swift
//  SwiftNetworkApp
//
//  Created by Kumar Mishra, R. F. on 6/12/18.
//  Copyright © 2018 Kumar Mishra, R. F. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct CountryManager {
    
    // Implementation of singleton in Swift
//    static let sharedManager = CountryManager()
//    private init(){
//        
//    }
    
    
    
    static let environment : NetworkEnvironment = .production
    let router = Router<CountryApi>()
    
    func getCountryList(completion: @escaping (_ country: [Fact]?,_ error: String?)->()){
        router.request(.country) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                        guard let responseFormatedData = String(data: responseData, encoding: .isoLatin1) else { return }
                        print("responseFormatedData: \(responseFormatedData)")
//                        let test = String(responseFormatedData.filter { !" \n\t\r".contains($0) })
                        let newData = responseFormatedData.data(using: String.Encoding.utf8)
                    
                        do {
                            let countryInfo = try JSONDecoder().decode(CountryInfo.self, from: newData!)
                            completion(countryInfo.rows,nil)
                            
                        } catch {
                            print(error.localizedDescription)
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }


                        
//                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
//                        print("jsonData: \(jsonData)")
                        
                        
//                        let apiResponse = try JSONDecoder().decode(CountryListResponse.self, from: responseData)
//                        completion(apiResponse.countries,nil)
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    
}
