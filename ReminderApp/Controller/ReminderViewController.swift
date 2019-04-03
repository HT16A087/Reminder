//
//  ReminderViewController.swift
//  ReminderApp
//
//  Created by admin on 2019/03/31.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ReminderViewController: UICollectionViewController {
    
    fileprivate var reminderData: ReminderData!
    
    fileprivate let headerId = "headerId"
    fileprivate let cellId = "cellId"
    fileprivate let padding: CGFloat = 16.0
    
    fileprivate let naviImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "timerImage")
        let imageTemp = image?.withRenderingMode(.alwaysTemplate)
        imageView.image = imageTemp
        imageView.tintColor = UIColor.black
        return imageView
    }()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reminderData = ReminderData()
        reminderData.loadData()
        
        setupNavigationItems()
        
        updateRemindersCountNotification()
        
        collectionView.reloadData()
    }
    
    // MARK: - UINavigationBar
    
    fileprivate func setupNavigationItems() {
        setupRemainingNavItem()
        setupLeftNavItem()
        setupRightNavItem()
    }
    
    fileprivate func setupRemainingNavItem() {
        navigationItem.titleView = naviImageView
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    fileprivate func setupLeftNavItem() {
        navigationItem.leftBarButtonItem = editButtonItem
        if reminderData.count() == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    fileprivate func setupRightNavItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTap(sender:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - UICollectionView
    
    fileprivate func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(ReminderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ReminderCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
    }
    
    // MARK: - UICollectionReusableView
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? ReminderHeaderView
        return header!
    }
    
    // MARK: - UICollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reminderData.count()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReminderCell
        cell.dataSourceItem = reminderData.data(at: indexPath.row)
        cell.isChecked = reminderData.data(at: indexPath.row)!.check
        cell.delegate = self
        return cell
    }
    
    // MARK: - UIScrollView
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    // MARK: - UINavigationBarItem
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // 利用不可に設定
        collectionView.allowsSelection = !editing
        navigationItem.rightBarButtonItem?.isEnabled = !editing
        if reminderData.count() == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
        
        // 編集モードに変更
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? ReminderCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    // MARK: - NSNotification
    
    func updateRemindersCountNotification() {
        let center = NotificationCenter.default
        center.post(name: .reminderCountLabelUpdate, object: nil)
    }
    
    // MARK: - ButtonAction Handling
    
    @objc func addButtonDidTap(sender: Any) {
        let addVc = AddReminderViewController()
        navigationController?.pushViewController(addVc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReminderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * padding, height: 60)
    }
}

// MARK: - ReminderCell Delegate

extension ReminderViewController: ReminderCellDelegate {
    
    func check(cell: ReminderCell) {
        cell.isChecked = !cell.isChecked
        
        if let indexPath = collectionView?.indexPath(for: cell) {
            let text = reminderData.data(at: indexPath.row)?.text
            let duedate = reminderData.data(at: indexPath.row)?.duedate
            reminderData.editData(reminder: Reminder(text: text!, duedate: duedate!, check: cell.isChecked), at: indexPath.row)
        }
        
        updateRemindersCountNotification()
    }
    
    func delete(cell: ReminderCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            reminderData.deleteData(at: indexPath.row)
            collectionView?.deleteItems(at: [indexPath])
        }
        
        updateRemindersCountNotification()
        
        if reminderData.count() == 0 {
            cell.isEditing = false
            
            UIView.animate(withDuration: 0.5) {
                self.collectionView.reloadEmptyDataSet()
            }
        }
    }
}

// MARK: - DANEmpty DataSource

extension ReminderViewController: DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "timerImage")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Reminders"
        return NSAttributedString(string: text, attributes: nil)
    }
}

// MARK: - DANEmpty DataSetDelegate

extension ReminderViewController: DZNEmptyDataSetDelegate {}
