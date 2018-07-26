//
//  Places.swift
//  SwiftNetworkApp
//
//  Created by r.f.kumar.mishra on 18/07/18.
//  Copyright © 2018 Kumar Mishra, R. F. All rights reserved.
//

import Foundation


struct Places {
    
    var placeName : String?
    var placeImage : String?
    
    init(placeName:String, placeImage:String) {
        self.placeName =  placeName
        self.placeImage = placeImage
    }
}
