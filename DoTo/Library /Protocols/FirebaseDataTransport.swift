//
//  FirebaseDataTransport.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 2/2/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseDataTransport {    
    func fetchData(path: String?) -> Void
}

extension FirebaseDataTransport {
    func fetchData(path: String?) { return }
}
