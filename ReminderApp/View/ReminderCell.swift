//
//  ReminderCell.swift
//  ReminderApp
//
//  Created by admin on 2019/03/31.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol ReminderCellDelegate: class {
    func check(cell: ReminderCell)
    func delete(cell: ReminderCell)
}

class ReminderCell: UICollectionViewCell {
    
    weak var delegate: ReminderCellDelegate?
    
    var dataSourceItem: Any? {
        didSet {
            guard let reminder = dataSourceItem as? Reminder else { return }
            taskLabel.text = reminder.text
            duedateLabel.text = setDueDateText(dueDate: reminder.duedate)
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            if self.isChecked {
                checkCell()
            } else {
                unCheckCell()
            }
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteButton.alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                self.deleteButton.alpha = 1.0
            }
            checkButton.isHidden = self.isEditing
            deleteButton.isHidden = !self.isEditing
        }
    }
    
    fileprivate let checkButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "uncheckImage")
        let imageTemp = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(imageTemp, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let deleteButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.red
        let image = UIImage(named: "deleteImage")
        let imageTemp = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(imageTemp, for: .normal)
        button.isHidden = true
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.lineBreakMode = .byTruncatingTail//.byWordWrapping
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let duedateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let gradView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupViews()
        setupLayer()
        
        checkButton.addTarget(self, action: #selector(checkButtonDidTap(sender:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTap(sender:)), for: .touchUpInside)
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
    
    func setupViews() {
        self.addSubview(checkButton)
        self.addSubview(deleteButton)
        self.addSubview(taskLabel)
        self.addSubview(duedateLabel)
        self.addSubview(gradView)
        
        // Constraints
        checkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        checkButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        checkButton.rightAnchor.constraint(equalTo: taskLabel.leftAnchor, constant: -8).isActive = true
        checkButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: checkButton.topAnchor).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: checkButton.leftAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: checkButton.rightAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: checkButton.bottomAnchor).isActive = true
        
        taskLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        taskLabel.rightAnchor.constraint(equalTo: duedateLabel.leftAnchor, constant: -8).isActive = true
        taskLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        
        duedateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        duedateLabel.leftAnchor.constraint(equalTo: taskLabel.rightAnchor, constant: 8).isActive = true
        duedateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        duedateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        duedateLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        gradView.topAnchor.constraint(equalTo: self.topAnchor, constant: -3).isActive = true
        gradView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
    }
    
    func setupLayer() {
        setGradationLayer(view: gradView)
        
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
    }
    
    func setDueDateText(dueDate: String) -> String {
        if dueDate != "" {
            let _dueDate = comvertStringToDate(dueDate: dueDate)
            
            let date: String = setDate(dueDate: _dueDate)
            let time: String = setTime(dueDate: _dueDate)
            
            let dueDateStr = date + "\n" + time
            return dueDateStr
        } else {
            return ""
        }
    }
    
    func comvertStringToDate(dueDate: String) -> Date {
        // Date to string
        // ??? 関数内で DateFormatter のインスタンスを生成しないとエラーが発生
        let convertFormatter = DateFormatter()
        convertFormatter.timeZone = NSTimeZone.local
        convertFormatter.locale = Locale(identifier: "en_US_POSIX")
        convertFormatter.dateStyle = .medium
        convertFormatter.timeStyle = .short
        let dateStr = convertFormatter.date(from: dueDate)!
        return dateStr
    }
    
    func setDate(dueDate: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        
        let date = dateFormatter.string(from: dueDate)
        return date
    }
    
    func setTime(dueDate: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let time = dateFormatter.string(from: dueDate)
        return time
    }
    
    // MARK: - CAGradientLayer
    
    func setGradationLayer(view: UIView) {
        let gradLayer = CAGradientLayer()
        gradLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 3)
        gradLayer.colors = [ UIColor.magenta.cgColor, UIColor.blue.cgColor ]
        gradLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradLayer.cornerRadius = 1.0
        view.layer.insertSublayer(gradLayer, at: 0)
    }
    
    func checkCell() {
        let image = UIImage(named: "checkImage")
        let imageTemp = image?.withRenderingMode(.alwaysTemplate)
        checkButton.setImage(imageTemp, for: .normal)
        
        taskLabel.textColor = UIColor.lightGray
        duedateLabel.textColor = UIColor.lightGray
    }
    
    func unCheckCell() {
        let image = UIImage(named: "uncheckImage")
        let imageTemp = image?.withRenderingMode(.alwaysTemplate)
        checkButton.setImage(imageTemp, for: .normal)
        
        taskLabel.textColor = UIColor.black
        duedateLabel.textColor = UIColor.black
    }
    
    // ButtonAction Handling
    
    @objc func checkButtonDidTap(sender: UIButton) {
        delegate?.check(cell: self)
    }
    
    @objc func deleteButtonDidTap(sender: Any) {
        delegate?.delete(cell: self)
    }
}
