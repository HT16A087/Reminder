//
//  ReminderViewController.swift
//  ReminderApp
//
//  Created by admin on 2019/04/20.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ReminderViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var reminderData: ReminderData!
    
    fileprivate var headerView: ReminderHeaderView!
    fileprivate let headerId = "headerId"
    fileprivate let cellId = "cellId"
    fileprivate let padding: CGFloat = 16.0
    
    fileprivate let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "titleImage")
        return imageView
    }()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not veen implemented")
    }
    
    // MARK: - CollectionView
    fileprivate func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            layout.minimumLineSpacing = 30
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(ReminderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ReminderCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
    }
    
    // MARK: - HeaderView
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? ReminderHeaderView
        headerView.reminderNum = reminderData.count()
        return headerView
    }
 
    
    // MARK: - CollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reminderData.count()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReminderCell
        cell.dataSorceItem = reminderData.data(at: indexPath.row) 
        cell.isChecked = reminderData.checkData(at: indexPath.row)!
        cell.delegate = self
        return cell
    }
    
    // MARK: - CollectionView DelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * padding, height: 65)
    }
    
    // MARK: - ScrollView
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    // MARK: - View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reminderData = ReminderData()
        reminderData.loadData()
        reminderData.loadCheck()
        
        setupNavigationItems()
        collectionView.reloadData()
    }
}

extension ReminderViewController {
    
    // MARK - NavigationItem
    
    private func setupNavigationItems() {
        setupRemainingItems()
        setupLeftNavItem()
        setupRightNavItem()
    }
    
    private func setupRemainingItems() {
        navigationItem.titleView = titleImageView
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupLeftNavItem() {
        navigationItem.leftBarButtonItem = editButtonItem
        if reminderData.count() == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    private func setupRightNavItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTap(sender:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - Action
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        navigationItem.rightBarButtonItem?.isEnabled = !editing
        
        if reminderData.count() == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? ReminderCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    @objc func addButtonDidTap(sender: Any) {
        let nextVc = AddReminderViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(nextVc, animated: true)
    }
}

// MARK: - ReminderCellDelegate

extension ReminderViewController: ReminderCellDelegate {
    
    func check(cell: ReminderCell) {
        cell.isChecked = !cell.isChecked
        
        if let indexPath = collectionView?.indexPath(for: cell) {
            reminderData.changeCheckState(at: indexPath.row)
        }
    }
    
    func delete(cell: ReminderCell) {
        cell.isEditing = false
        
        if let indexPath = collectionView?.indexPath(for: cell) {
            reminderData.deleteData(at: indexPath.row)
            reminderData.deleteCheck(at: indexPath.row)
            collectionView?.deleteItems(at: [indexPath])
            headerView.reminderNum = reminderData.count()
            
            if reminderData.count() == 0 {
                collectionView.reloadEmptyDataSet()
            }
        }
    }
}

// MARK: - DZNEmpty Delegate

extension ReminderViewController: DZNEmptyDataSetDelegate {}

// MARK: - DZNEmpty DataSource

extension ReminderViewController: DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage? {
        return UIImage(named: "titleImage")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Reminders"
        return NSAttributedString(string: text, attributes: nil)
    }
}
