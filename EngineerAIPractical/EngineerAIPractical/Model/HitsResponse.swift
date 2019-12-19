//
//  HitsResponse.swift
//  EngineerAIPractical
//
//  Created by PCQ111 on 19/12/19.
//  Copyright © 2019 PCQ111. All rights reserved.
//

import Foundation

class HitsResponse: Codable {
    let page         : Int?
    let hitsPerPage  : Int?
    let nbPages      : Int?
    let hits         : [HitsList]?
    
}

class HitsList : Codable {
    let created_at  : String?
    let title       : String?
    var isActive    : Bool?
    
}

