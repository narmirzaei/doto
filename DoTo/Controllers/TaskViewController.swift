//
//  TaskViewController.swift
//  DoTo
//
//  Created by Narbeh Mirzaei on 2/1/18.
//  Copyright © 2018 Narbeh Mirzaei. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseDatabase

class TaskViewController: BaseViewController, FirebaseDataTransport {
    public var task = TaskModel(date: Date(), header: "", desc: "")
    
    private var _ref: DatabaseReference!
    private var _handlerTaskUpdate: DatabaseHandle?

    private let datePickerView: UIDatePicker = {
        let _datePickerView = UIDatePicker()
        _datePickerView.datePickerMode = UIDatePickerMode.date
        return _datePickerView
    }()
    
    private let datePickerTextfield = UITextField()
    
    @IBOutlet weak var descTextfield: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBAction func dateButtonTapped(_ sender: Any) {
        datePickerTextfield.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.modelObservers = [
            task.observe(\.date, options: [.initial]) { (task, change) in
                self.dateButton.setTitle(DateHelper.dateString(from: task.date), for: .normal)
            },
            task.observe(\.desc, options: [.initial]) { (task, change) in
                self.descTextfield.text = task.desc
            }
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        _ref = { (task: TaskModel?) -> DatabaseReference in
            guard let _uid = task?.uid else {
                return Database.database().reference(withPath: "tasks").childByAutoId()
            }
            return Database.database().reference(withPath: "tasks/\(_uid)")
        }(task)
        
        task.uid = _ref.key
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for observer in self.modelObservers {
            observer.invalidate()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupUserInterface() {
        view.addSubview(datePickerTextfield)
        datePickerTextfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(taskDateValueChanged(sender:)), for: .valueChanged)
        
        let saveSwipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(saveTask))
        saveSwipeDownGesture.direction = .down
        view.addGestureRecognizer(saveSwipeDownGesture)
    }
    
    @objc func taskDateValueChanged(sender: UIDatePicker) {
        task.date = sender.date
    }
    
    @objc func saveTask() {
        self.dismiss(animated: true, completion: {
            guard let _date = DateHelper.dateString(from: self.task.date), self.descTextfield.text?.isEmpty == false else {
                return
            }
            
            self._ref.updateChildValues([
                "date": _date,
                "desc": self.descTextfield.text!
            ]) { (error, ref) in
                error == nil ? HUD.flash(.success) : HUD.flash(.error)
            }
        })
    }
}
