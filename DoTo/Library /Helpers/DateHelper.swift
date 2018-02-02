//
//  DateHelper.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 2/1/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import Foundation

class DateHelper {
    private static var dateFormatter : DateFormatter = {
        var _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "yyyy-MM-dd"
        return _dateFormatter
    }()
    
    static func date(from serviceDateString: String?) -> Date? {
        if let sds = serviceDateString {
            guard let date = dateFormatter.date(from: sds) else {
                fatalError("ERROR: Date conversion failed due to mismatched format.")
            }
            
            return date
        }
        
        return nil
    }
    
    static func dateString(from localDate: Date?) -> String? {
        if let ld = localDate {
            return dateFormatter.string(from: ld)
        }
        
        return nil
    }
}
