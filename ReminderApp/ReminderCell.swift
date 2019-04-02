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
            
            let dueText = duedateTextChangeFormat(duedate: reminder.duedate)
            duedateLabel.text = dueText
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
        label.text = "Test Test Test"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        //label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let duedateLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Test Test"
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        //label.backgroundColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let gradView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        // Setup subviews
        setupViews()
        
        // Setup layout
        setupLayer()
        
        // Setup button action
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
        duedateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        duedateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        
        gradView.topAnchor.constraint(equalTo: self.topAnchor, constant: -3).isActive = true
        gradView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
    }
    
    func setupLayer() {
        // グラデーション
        setGradation(view: gradView)
        
        // 角丸
        self.layer.cornerRadius = 3.0
        
        // 影
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
    }
    
    // MARK: - CAGradientLayer
    
    func setGradation(view: UIView) {
        let gradLayer = CAGradientLayer()
        gradLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 3)
        gradLayer.colors = [ UIColor.magenta.cgColor, UIColor.blue.cgColor ]
        gradLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradLayer.cornerRadius = 1.0
        view.layer.insertSublayer(gradLayer, at: 0)
    }
    
    // Test
    func duedateTextChangeFormat(duedate: String) -> String {
        // 表示したいフォーマットに変換
        let formatter = DateFormatter()
        formatter.locale = NSLocale.init(localeIdentifier: "en-US") as Locale
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dueDate: Date = formatter.date(from: duedate)!
        formatter.doesRelativeDateFormatting = true
        let dueStr: String = formatter.string(from: dueDate)
        let separatedStringArray = dueStr.components(separatedBy: .whitespaces)
        print(separatedStringArray[0])
        print(separatedStringArray[2] + separatedStringArray[3])
        let A = separatedStringArray[0] + "\n" + separatedStringArray[2] + " " + separatedStringArray[3]        
        return A
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
