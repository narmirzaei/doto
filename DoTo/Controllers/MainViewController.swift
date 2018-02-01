//
//  MainViewController.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 2/1/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainViewController: UITableViewController {
    var tasksGrouped: [String: [TaskModel]] = [:]
    var tasksGroupedSortedKeys : [String] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        
        ref = Database.database().reference()
        ref.child("tasks").observe(.value) { (snapshot) in
            var _tasks = [TaskModel]()
            if let tasksArray = snapshot.value as? NSArray {
                for task in tasksArray {
                    if let _task = task as? NSDictionary {
                        _tasks.append(TaskModel(date: DateHelper.date(from: _task["date"] as? String) , header: _task["header"] as? String, desc: _task["desc"] as? String))
                    }
                }
            }
            
            self.tasksGrouped = groupTasksByDate(_tasks)
            self.tasksGroupedSortedKeys = self.tasksGrouped.keys.sorted()
            self.tableView.reloadData()
        }
    }
    
    //MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasksGroupedSortedKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksGrouped[tasksGroupedSortedKeys[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tasksGroupedSortedKeys[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as? TaskTableViewCell {
            let model = tasksGrouped[tasksGroupedSortedKeys[indexPath.section]]![indexPath.row]
            cell.taskHeaderLabel.text = model.header
            cell.taskDescLabel.text = model.desc
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    //MARK: UITableViewDelegate

    deinit {
        
    }
}

//MARK: Private methods
private func groupTasksByDate(_ data: [TaskModel]?) -> [String: [TaskModel]] {
    var tasksMap = [String: [TaskModel]]()
    
    if let data = data {
        for task in data {
            if let date = task.date {
                var components = NSCalendar.current.dateComponents([.day, .month, .year], from: date)
                let key = getKey(year: components.year, month: components.month, day: components.day)
                if tasksMap.keys.contains(where:{ (_key) -> Bool in return _key == key }) {
                    tasksMap[key]?.append(task)
                } else {
                    tasksMap[key] = [task]
                }
            }
        }
    }

    return tasksMap
}

private func getKey(year: Int?, month: Int?, day: Int?) -> String {
    return "\(year ?? 0)-\(month ?? 0)-\(day ?? 0)"
}
