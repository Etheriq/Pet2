//
//  DateExtension.swift
//  swift-server
//
//  Created by Yuriy T on 10.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import Foundation

extension DateFormatter {    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)      // uncomment this to force UTC
        
        return formatter
    }()
}
