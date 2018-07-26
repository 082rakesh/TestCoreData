//
//  Country.swift
//  SwiftNetworkApp
//
//  Created by Kumar Mishra, R. F. on 6/12/18.
//  Copyright © 2018 Kumar Mishra, R. F. All rights reserved.
//

import Foundation


struct CountryInfo : Decodable {
    let title: String?
    let rows : [Fact]?
}

///- Fact : data model for country facts
struct Fact: Decodable {
    let title: String?
    var description: String?
    let imageHref: String?
}



