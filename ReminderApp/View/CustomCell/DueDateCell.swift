//
//  DueDateCell.swift
//  ReminderApp
//
//  Created by admin on 2019/04/21.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DueDateCell: UICollectionViewCell {
    
    fileprivate let duedateLabel: UILabel = {
        let label = UILabel()
        label.text = "Duedate"
        label.textColor = UIColor.black
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let duedateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let dueDateTextField: DatePickerTextField = {
        let textField = DatePickerTextField()
        textField.textColor = UIColor.black
        textField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate let duedatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    fileprivate let datepickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        return toolBar
    }()
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setupViews()
        setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - View
    
    fileprivate func setupViews() {
        self.addSubview(duedateLabel)
        self.addSubview(dueDateTextField)
        
        setupDueDateTextField()
        setupDatePickerToolBarItems()
        
        duedatePicker.addTarget(self, action: #selector(didValueChangedDatePicker(sender:)), for: .valueChanged)
        
        duedateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        duedateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        dueDateTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        dueDateTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupDueDateTextField() {
        let now = Date()
        dueDateTextField.text = dateFormatter.string(from: now)
        
        dueDateTextField.inputView = duedatePicker
        dueDateTextField.inputAccessoryView = datepickerToolBar
    }
    
    private func setupDatePickerToolBarItems() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDoneButtonDidTap(sender:)))
        datepickerToolBar.items = [ spacer, done ]
    }
    
    // MARK: - Layer
    
    fileprivate func setupLayer() {
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
    }
    
    // MARK: - Action
    
    @objc func datePickerDoneButtonDidTap(sender: UIButton) {
        dueDateTextField.resignFirstResponder()
    }
    
    @objc func didValueChangedDatePicker(sender: UIDatePicker) {
        let selectedDateAndTime = dateFormatter.string(from: sender.date)
        dueDateTextField.text = selectedDateAndTime
    }
    
    func getDate() -> String {
        return dueDateTextField.text!
    }
}

extension DueDateCell {
    
    // MARK: - Custom TextField
    
    class DatePickerTextField: UITextField {
        
        override func caretRect(for position: UITextPosition) -> CGRect {
            return CGRect.zero
        }
        
        override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
            return []
        }

        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return false
        }
    }
}


