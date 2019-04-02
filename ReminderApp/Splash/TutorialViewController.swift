//
//  TutorialViewController.swift
//  ReminderApp
//
//  Created by admin on 2019/04/02.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    fileprivate let tutorialScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    fileprivate let tutorialPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    fileprivate let imageNames = [String]()
    
    fileprivate let loginStateKey = "isFirstTimeDone"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.backgroundColor = UIColor.white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.view.addSubview(tutorialScrollView)
        
        tutorialScrollView.delegate = self
        
        // Constraints
        
    }
    
    func createTutorialPage() {
        let pageSize = 3
        for i in 0 ..< pageSize {
            let image = UIImage(named: imageNames[i])
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: CGFloat(i) + view.frame.width, y: 0, width: view.frame.width, height: view.frame.height - 50)
        }
    }
    
    // チュートリアルが過去に実行されたか確認
    func isTutorialDone() -> Bool {
        let defaults = UserDefaults.standard
        let loginState: Bool = defaults.bool(forKey: loginStateKey)
        if loginState {
            return false
        }
        return true
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    
    
}
