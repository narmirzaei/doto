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
        for observer in self.modelObservers {
            observer.invalidate()
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupUserInterface() {
        view.addSubview(datePickerTextfield)
        datePickerTextfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(taskDateValueChanged(sender:)), for: .valueChanged)
        
        let saveDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(saveTask))
        saveDoubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(saveDoubleTapGesture)
    }
    
    @objc func taskDateValueChanged(sender: UIDatePicker) {
        task.date = sender.date
    }
    
    @objc func saveTask() {
        guard let _date = DateHelper.dateString(from: task.date), descTextfield.text?.isEmpty == false else {
            return
        }
        
        _ref.updateChildValues([
            "date": _date,
            "desc": descTextfield.text!
        ]) { (error, ref) in
                if(error == nil) {
                    HUD.flash(.success, delay: 0.2) { finished in
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    HUD.flash(.error)
                }
            }
    }
}
