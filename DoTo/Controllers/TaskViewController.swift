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
    
    @IBOutlet weak var headerTextfield: UITextField!
    @IBOutlet weak var descTextview: UITextView!
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
        
        let saveDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(saveTask))
        saveDoubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(saveDoubleTapGesture)
    }
    
    @objc func taskDateValueChanged(sender: UIDatePicker) {
        dateButton.setTitle(DateHelper.dateString(from: sender.date), for: .normal)
    }
    
    @objc func saveTask() {
        let _refHandle = ref.child("tasks").childByAutoId()
        
        _refHandle.updateChildValues([
            "date": DateHelper.dateString(from: datePickerView.date) ?? "",
            "header": headerTextfield.text ?? "",
            "desc": descTextview.text]) { (error, ref) in
                if(error == nil) {
                    HUD.flash(.success, delay: 0.4) { finished in
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    HUD.flash(.error)
                }
            }
    }
}
