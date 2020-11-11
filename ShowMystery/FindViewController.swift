//
//  FindViewController.swift
//  ShowMystery
//
//  Created by Vahe Toroyan on 11/8/20.
//

import UIKit
import SwiftUI

class FindViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    var hideStatusBar: Bool = true

    override var prefersStatusBarHidden: Bool {
           return hideStatusBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = UIHostingController(rootView: FindView())
        addChild(childView)
        childView.view.frame = containerView.bounds
        containerView.addConstrained(subview: childView.view)
        childView.didMove(toParent: self)
    }
}

extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
