//
//  AddReminaderViewController.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AddReminderViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var task: String?
    var due: Date?
    
    fileprivate let reminderData: ReminderData
    
    fileprivate let headerId = "headerId"
    fileprivate let taskCellId = "taskCell"
    fileprivate let remindCellId = "remindCell"
    fileprivate let duedateCellId = "duedateCell"
    fileprivate let padding: CGFloat = 16.0
    
    fileprivate var hasAddingItem = false
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        self.reminderData = ReminderData()
        self.reminderData.loadData()
        self.reminderData.loadCheck()
        super.init(collectionViewLayout: layout)
        
        setupNavigationItems()
        
        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CollectionView
    
    fileprivate func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        
        collectionView.register(AddReminderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: taskCellId)
        collectionView.register(RemindCell.self, forCellWithReuseIdentifier: remindCellId)
        collectionView.register(DueDateCell.self, forCellWithReuseIdentifier: duedateCellId)
    }
    
    // MARK: - AddReminderHeaderView
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AddReminderHeaderView
        return headerView
    }
    
    // MARK: - CollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + (hasAddingItem ? 1 : 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let taskCell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCellId, for: indexPath) as! TaskCell
        let remindCell = collectionView.dequeueReusableCell(withReuseIdentifier: remindCellId, for: indexPath) as! RemindCell
        remindCell.delegate = self
        let duedateCell = collectionView.dequeueReusableCell(withReuseIdentifier: duedateCellId, for: indexPath) as! DueDateCell
        
        let itemNum = indexPath.row
        if itemNum == 0 {
            return taskCell
        }
        
        if itemNum == 1 {
            return remindCell
        }
        
        return duedateCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * padding, height: 65)
    }
}

extension AddReminderViewController {
    
    // MARK: - NavigationItem
    
    private func setupNavigationItems() {
        setupRightNavItem()
    }
    
    private func setupRightNavItem() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonDidTap(sender:)))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // MARK: - Action
    
    @objc func saveButtonDidTap(sender: Any) {
        
        // get data
        var task: String = ""
        if let taskCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? TaskCell {
            task = taskCell.getText()
        }
        
        var duedate: String = ""
        if let duedateCell = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? DueDateCell {
            duedate = duedateCell.getDate()
        }
        
        // save item
        if task != "" {
            let reminder = Reminder(task: task, duedate: duedate)
            reminderData.saveData(reminder: reminder)
            reminderData.saveCheck(check: false)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ReminderCellDelegate

extension AddReminderViewController: RemindeCellDelegate {
    
    func changeCellDisplay() {
        hasAddingItem = !hasAddingItem
        
        let indexPath = IndexPath(item: 2, section: 0)
        
        if hasAddingItem {
            collectionView.insertItems(at: [indexPath])
        } else {
            collectionView.deleteItems(at: [indexPath])
        }
    }
}
