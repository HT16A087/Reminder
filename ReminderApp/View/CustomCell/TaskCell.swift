//
//  TaskCell.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol TaskCellDelegate: class {
    func kbDone(textField: UITextField)
}

class TaskCell: UICollectionViewCell {
    
    weak var delegate: TaskCellDelegate?
    
    fileprivate let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "What do you want to get done?"
        textField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        self.addSubview(taskTextField)
        
        taskTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        taskTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        taskTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        taskTextField.delegate = self
    }
    
    // MARK: - Layer
    
    fileprivate func setupLayer() {
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
    }
    
    func getText() -> String {
        return taskTextField.text!
    }
}

// MARK: - TextField Delegate

extension TaskCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        taskTextField.returnKeyType = .done
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
