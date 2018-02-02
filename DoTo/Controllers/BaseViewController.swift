//
//  BaseViewController.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 2/1/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var modelObservers = [NSKeyValueObservation]()
    
    func setupUserInterface() { return }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
    }
}
