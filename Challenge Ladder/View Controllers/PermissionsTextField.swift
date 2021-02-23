//
//  PermissionsViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 26/11/2020.
//

import UIKit



class PermissionsTextField: UITextField, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var tempPermission: LadderPermission!
    var picker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return LadderPermission.allCases[row].rawValue
       }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        LadderPermission.allCases.count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 15)
        self.borderStyle = UITextField.BorderStyle.line
        self.autocorrectionType = UITextAutocorrectionType.no
        self.backgroundColor = .clear
        self.textColor = .black
        self.textAlignment = .center
        self.keyboardType = UIKeyboardType.numberPad
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        picker = UIPickerView()
                
        picker.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.3)
        
        self.inputView = picker
        picker.dataSource = self
        picker.delegate = self
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(pickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(pickerCancelled))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.inputAccessoryView = toolBar
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempPermission = LadderPermission.allCases[row]
    }
    
    
    @objc func pickerCancelled() {
        self.resignFirstResponder()
    }
    
    @objc func buttonClicked() {
        self.becomeFirstResponder()
    }
 
    
    @objc func pickerDone() {
        if tempPermission == nil{
            tempPermission = .open
        }
        self.text = tempPermission.rawValue
        pickerCancelled()
    }
    
}

