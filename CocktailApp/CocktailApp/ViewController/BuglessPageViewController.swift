//
//  BuglessPageViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import UIKit

class BuglessPageViewController: UIPageViewController {
    private var preventScrollBug = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
    }

    override func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        preventScrollBug = false
        super.setViewControllers(viewControllers, direction: direction, animated: animated) { [weak self] completed in
            self?.preventScrollBug = true
            if completion != nil {
                completion!(completed)
            }
        }
    }
}

extension BuglessPageViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        preventScrollBug = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if preventScrollBug {
            scrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            preventScrollBug = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        preventScrollBug = true
    }
}

extension UIPageViewController {
    var scrollView: UIScrollView! {
        for view in view.subviews {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
        }
        
        return nil
    }
}
