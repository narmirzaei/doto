//
//  Task.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 1/31/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import Foundation

class TaskModel: BaseModel {
    var date: Date?
    var header: String?
    var desc: String?
    
    convenience init(date: Date?, header: String?, desc: String?) {
        self.init()
        
        self.date = date
        self.header = header
        self.desc = desc
    }
}
