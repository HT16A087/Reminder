//
//  AddReminderViewController.swift
//  ReminderApp
//
//  Created by admin on 2019/04/01.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import UserNotifications

class AddReminderViewController: UIViewController {
    
    var text: String?
    var duedate: String?
    
    fileprivate var reminderData: ReminderData!
    
    fileprivate let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a new reminder"
        label.font = UIFont(name: "AvenirNext-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let box1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let box2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let box3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let remindTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "What do you want to get done?"
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate let remindLabel: UILabel = {
        let label = UILabel()
        label.text = "Remind Me"
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let remindSwitch: UISwitch = {
        let _switch = UISwitch()
        _switch.isOn = false
        _switch.addTarget(self, action: #selector(remindSwitchDidTap(sender:)), for: .touchUpInside)
        _switch.translatesAutoresizingMaskIntoConstraints = false
        return _switch
    }()
    
    fileprivate let duedateLabel: UILabel = {
        let label = UILabel()
        label.text = "Due Date"
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let duedateButton: UIButton = {
        let button = UIButton()
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        button.setTitle(formatter.string(from: now), for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.isEnabled = true
        button.addTarget(self, action: #selector(duedateButtonDidTap(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let duedatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.timeZone = NSTimeZone.local
        picker.locale = Locale.current
        picker.addTarget(self, action: #selector(didValueChangedDatePicker(sender:)), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    fileprivate let kbToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(kbDoneButtonDidTap(sender:)))
        toolBar.items = [ spacer, done ]
        return toolBar
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.backgroundColor = UIColor.white
        
        setupNavigationItems()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        view.addSubview(headerLabel)
        view.addSubview(box1)
        view.addSubview(box2)
        
        box1.addSubview(remindTextField)
        box2.addSubview(remindLabel)
        box2.addSubview(remindSwitch)
        
        remindTextField.inputAccessoryView = kbToolBar
        
        // Constraints
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        box1.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 17).isActive = true
        box1.leftAnchor.constraint(equalTo: headerLabel.leftAnchor).isActive = true
        box1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        box1.bottomAnchor.constraint(equalTo: box1.topAnchor, constant: 60).isActive = true
        
        box2.topAnchor.constraint(equalTo: box1.bottomAnchor, constant: 25).isActive = true
        box2.leftAnchor.constraint(equalTo: headerLabel.leftAnchor).isActive = true
        box2.rightAnchor.constraint(equalTo: box1.rightAnchor).isActive = true
        box2.bottomAnchor.constraint(equalTo: box2.topAnchor, constant: 60).isActive = true
        
        remindTextField.topAnchor.constraint(equalTo: box1.topAnchor, constant: 16).isActive = true
        remindTextField.leftAnchor.constraint(equalTo: box1.leftAnchor, constant: 16).isActive = true
        remindTextField.rightAnchor.constraint(equalTo: box1.rightAnchor, constant: -16).isActive = true
        remindTextField.bottomAnchor.constraint(equalTo: box1.bottomAnchor, constant: -16).isActive = true
        
        remindLabel.topAnchor.constraint(equalTo: box2.topAnchor, constant: 16).isActive = true
        remindLabel.leftAnchor.constraint(equalTo: box2.leftAnchor, constant: 16).isActive = true
        remindLabel.rightAnchor.constraint(equalTo: box2.rightAnchor, constant: -16).isActive = true
        remindLabel.bottomAnchor.constraint(equalTo: box2.bottomAnchor, constant: -16).isActive = true
        
        remindSwitch.topAnchor.constraint(equalTo: remindLabel.topAnchor).isActive = true
        remindSwitch.rightAnchor.constraint(equalTo: box2.rightAnchor, constant: -16).isActive = true
        remindSwitch.bottomAnchor.constraint(equalTo: box2.bottomAnchor, constant: -16).isActive = true
    }
    
    fileprivate func setupNavigationItems() {
        setupRightNavItem()
    }
    
    fileprivate func setupRightNavItem() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonDidTap(sender:)))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        remindTextField.resignFirstResponder()
    }
    
    func indicateDueDateBox() {
        view.addSubview(box3)
        box3.addSubview(duedateLabel)
        box3.addSubview(duedateButton)
        
        box3.topAnchor.constraint(equalTo: box2.bottomAnchor, constant: 20).isActive = true
        box3.leftAnchor.constraint(equalTo: box2.leftAnchor).isActive = true
        box3.rightAnchor.constraint(equalTo: box2.rightAnchor).isActive = true
        box3.bottomAnchor.constraint(equalTo: box3.topAnchor, constant: 60).isActive = true
        
        duedateLabel.topAnchor.constraint(equalTo: box3.topAnchor, constant: 16).isActive = true
        duedateLabel.leftAnchor.constraint(equalTo: box3.leftAnchor, constant: 16).isActive = true
        duedateLabel.bottomAnchor.constraint(equalTo: box3.bottomAnchor, constant: -16).isActive = true
        
        duedateButton.topAnchor.constraint(equalTo: duedateLabel.topAnchor).isActive = true
        duedateButton.rightAnchor.constraint(equalTo: box3.rightAnchor, constant: -16).isActive = true
        duedateButton.bottomAnchor.constraint(equalTo: duedateLabel.bottomAnchor).isActive = true
        
        box3.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.box3.alpha = 1.0
        }
    }
    
    func hideDueDateBox() {
        UIView.animate(withDuration: 0.3) {
            self.box3.alpha = 0.0
        }
    }
    
    func resetDueDateButton() {
        duedateButton.setTitleColor(UIColor.lightGray, for: .normal)
        duedateButton.isEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.duedatePicker.alpha = 0.0
            self.view.willRemoveSubview(self.duedatePicker)
        }
    }
    
    // MARK: - Notification
    
    func notificationConfirmation() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // エラー処理
        }
    }
    
    // MARK: - NavigationBarButtonItem Handling
    
    @objc func saveButtonDidTap(sender: Any) {
        if remindTextField.text != "" {
            reminderData = ReminderData()
            let text = remindTextField.text
            let duedate = duedateButton.currentTitle
            reminderData.loadData()
            reminderData.saveData(reminder: Reminder(text: text!, duedate: duedate!, check: false))
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UISwitch Handling
    
    @objc func remindSwitchDidTap(sender: UISwitch) {
        if sender.isOn == true {
            indicateDueDateBox()
        } else {
            resetDueDateButton()
            hideDueDateBox()
        }
        
        notificationConfirmation()
    }
    
    // MARK: - DueDate Button And Picker Handling
    
    @objc func duedateButtonDidTap(sender: Any) {
        remindTextField.resignFirstResponder()
        
        self.view.addSubview(duedatePicker)
        duedatePicker.topAnchor.constraint(equalTo: box3.bottomAnchor, constant: 20).isActive = true
        duedatePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        duedatePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        duedateButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        duedateButton.isEnabled = false
        duedatePicker.alpha = 0.0
        duedatePicker.frame.origin.y = box3.frame.maxY
        UIView.animate(withDuration: 0.3) {
            self.duedatePicker.alpha = 1.0
            self.duedatePicker.frame.origin.y += 50
        }
    }
    
    @objc func didValueChangedDatePicker(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let selectedDate = formatter.string(from: sender.date)
        duedateButton.titleLabel?.text = selectedDate
        duedateButton.setTitle(selectedDate, for: .normal)
    }
    
    // MARK: - Keyboard Handling
    
    @objc func kbDoneButtonDidTap(sender: Any) {
        remindTextField.resignFirstResponder()
    }
}
