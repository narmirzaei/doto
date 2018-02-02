//
//  MainViewController.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 2/1/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseDatabase

class MainViewController: UITableViewController, FirebaseDataTransport {
    private var _ref: DatabaseReference!
    private var _handlerObserveTasksValueChange: DatabaseHandle?
    
    private var tasksGrouped: [String: [TaskModel]] = [:]
    private var tasksGroupedSortedKeys : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        
        _ref = Database.database().reference(withPath: "tasks")
    
        fetchData(path: nil)
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
            cell.taskDescLabel.text = model.desc
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    //MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TasksToTaskDetailSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TasksToTaskDetailSegue", let taskDetailViewController = segue.destination as? TaskViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                taskDetailViewController.task = tasksGrouped[tasksGroupedSortedKeys[selectedIndexPath.section]]![selectedIndexPath.row]
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    deinit {
        if let _refHandle = _handlerObserveTasksValueChange {
            _ref.removeObserver(withHandle: _refHandle)
        }
    }
    
    //MARK: FirebaseDataTransport
    func fetchData(path: String?) {
        HUD.show(.progress)
        
        _handlerObserveTasksValueChange = _ref.observe(.value, with: { (snapshot) in
            var _tasks = [TaskModel]()
            if let tasksCollection = snapshot.value as? NSDictionary {
                for (key, task) in tasksCollection {
                    if let _task = task as? NSDictionary {
                        _tasks.append(TaskModel(uid: key as? String, date: DateHelper.date(from: _task["date"] as? String) , header: _task["header"] as? String, desc: _task["desc"] as? String))
                    }
                }
                
                self.tasksGrouped = self.groupTasksByDate(_tasks)
                self.tasksGroupedSortedKeys = self.tasksGrouped.keys.sorted { $0 > $1 }
            } else {
                self.tasksGrouped.removeAll()
                self.tasksGroupedSortedKeys.removeAll()
            }
            
            self.tableView.reloadData()
            HUD.hide()
        }) { (error) in
            HUD.flash(.error)
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
}
