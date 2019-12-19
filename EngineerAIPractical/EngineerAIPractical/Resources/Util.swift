//
//  Util.swift
//  EngineerAIPractical
//
//  Created by PCQ111 on 19/12/19.
//  Copyright © 2019 PCQ111. All rights reserved.
//

import Foundation

class Util {
    
    class func changeDateStringFormat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "E, d MMMM yyyy HH:mm:ss a"
        dateFormatter.timeZone = TimeZone.current
        
        let formattedDate = dateFormatter.string(from: date!)
        return formattedDate
    }
    
}

