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

class TaskViewController: BaseViewController {
    var ref: DatabaseReference!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupUserInterface() {
        view.addSubview(datePickerTextfield)
        datePickerTextfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(taskDateValueChanged(sender:)), for: .valueChanged)
        updateDateButton(datePickerView.date)
        
        let saveDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(saveTask))
        saveDoubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(saveDoubleTapGesture)
    }
    
    @objc func taskDateValueChanged(sender: UIDatePicker) {
        updateDateButton(sender.date)
    }
    
    @objc func saveTask() {
        guard let _date = DateHelper.dateString(from: datePickerView.date), descTextfield.text?.isEmpty == false else {
            return
        }
        let _refHandle = ref.child("tasks").childByAutoId()
        
        _refHandle.updateChildValues([
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
    
    //MARK: Private methods
    private func updateDateButton(_ date: Date) {
        dateButton.setTitle(DateHelper.dateString(from: date), for: .normal)
    }
    
}
