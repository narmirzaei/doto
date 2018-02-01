//
//  TaskTableViewCell.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 1/31/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskHeaderLabel: UILabel!
    @IBOutlet weak var taskDescLabel: UILabel!
    
    override func awakeFromNib() {
        taskHeaderLabel.text = ""
        taskDescLabel.text = ""
    }
}
