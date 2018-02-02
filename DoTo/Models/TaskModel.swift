//
//  Task.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 1/31/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import Foundation

class TaskModel: BaseModel {
    @objc dynamic var date: Date?
    @objc dynamic var desc: String?
    
    convenience init(date: Date?, header: String?, desc: String?) {
        self.init(uid: nil, date: date, header: header, desc: desc)
    }
    
    convenience init (uid: String?, date: Date?, header: String?, desc: String?) {
        self.init()
        
        self.uid = uid
        self.date = date
        self.desc = desc
    }
}
