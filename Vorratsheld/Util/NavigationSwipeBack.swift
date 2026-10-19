//
//  NavigationSwipeBack.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import UIKit

// Zurückwischen geht so auch ohne Navigationsleiste
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
