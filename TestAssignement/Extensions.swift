//
//  Extensions.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 31.01.2021.
//

import Foundation
import UIKit

// MARK: - UIViewController

extension UIViewController {
    /// Creates an alert with given title, message and button title and shows it on the screen.
    ///
    /// - Parameters:
    ///   - title: Title of the alert.
    ///   - message: The message of the alert.
    ///   - buttonTitle: The text that appears on the button.
    ///
    func generateAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let newVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            newVC.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { action in
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            }))
            self.present(newVC, animated: true, completion: nil)
        }
    }
}

    // MARK: - UIView

extension UIView {
    /// Adds spring animation imitating button tap, also transform any UIView into button with its completion handler.
    /// - Parameters:
    ///   - fromStart: If set to true the animation starts from setting view to the "touchDown" state otherwise from "touchUp" state.
    ///   - startingScale: Tuple that contains both modificators for width and height in proportion to the original size.
    ///   - completion: If it is needed to respond to tapping the view, set a block of code that needed to be executed here.
    func springAnimation(fromStart: Bool, startingScale: (x: CGFloat, y: CGFloat), completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = false
            if fromStart {
                self.transform = CGAffineTransform(scaleX: startingScale.x, y: startingScale.y)
            }
            let difference = (x: 1 - startingScale.x, y: 1 - startingScale.y)
            let delta = (x: difference.x / 3, y: difference.y / 3)
            UIView.animate(withDuration: 0.08, delay: 0, options: [.curveLinear], animations: {
                self.transform = CGAffineTransform(scaleX: startingScale.x + delta.x, y: startingScale.x + delta.y)
            }, completion: {_ in
                UIView.animate(withDuration: 0.01, delay: 0, options: [.curveEaseIn], animations: {
                    self.transform = CGAffineTransform(scaleX: 1 + delta.x, y: 1 + delta.y)
                }, completion: {_ in
                    UIView.animate(withDuration: 0.01, delay: 0, options: [.curveEaseOut], animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: {_ in
                        completion?()
                        self.isUserInteractionEnabled = true
                    })
                })
            })
        }
    }
}
