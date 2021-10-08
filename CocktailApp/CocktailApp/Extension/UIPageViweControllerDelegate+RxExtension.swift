//
//  UIPageViweControllerDelegate+RxExtension.swift
//  CocktailApp
//
//

import UIKit
import RxCocoa
import RxSwift

class RxUIPageViewControllerDelegateProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate>,
                                           DelegateProxyType,
                                           UIPageViewControllerDelegate {
    static func registerKnownImplementations() {
        self.register {
            RxUIPageViewControllerDelegateProxy(parentObject: $0, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: UIPageViewController) -> UIPageViewControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UIPageViewControllerDelegate?, to object: UIPageViewController) {
        object.delegate = delegate
    }
}

// PageViewController Rx Extension

extension Reactive where Base: UIPageViewController {
    var delegate: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate> {
        return RxUIPageViewControllerDelegateProxy.proxy(for: self.base)
    }
    
    var willTransitionToViewControllers: Observable<[UIViewController]> {
        return delegate.methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:willTransitionTo:)))
            .map { parameters in
                return parameters[1] as? [UIViewController] ?? []
            }
    }
}
