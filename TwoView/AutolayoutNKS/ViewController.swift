//
//  ViewController.swift
//  AutolayoutNKS
//
//  Created by Godrick Mayweather on 25.10.2021.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet var redView: UIView!
    @IBOutlet var blueView: UIView!
    @IBOutlet var redViewTrailingSafeAreaTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var blueViewLeadingSafeAreaLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var redViewBottomBlueViewTopConstraint: NSLayoutConstraint!

    func sizeClassConstraintCoordinator() {
        let redViewTrailingBlueViewLeadingConstraint =
        redView.trailingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: -16)
        let redViewTopBlueViewTopConstraint = redView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor)
        redViewTrailingBlueViewLeadingConstraint.priority = UILayoutPriority(999)
        redViewTopBlueViewTopConstraint.priority = UILayoutPriority(999)

        if self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {
            redViewTrailingSafeAreaTrailingConstraint.isActive = false
            blueViewLeadingSafeAreaLeadingConstraint.isActive = false
            redViewBottomBlueViewTopConstraint.isActive = false
            redViewTrailingBlueViewLeadingConstraint.isActive = true
            redViewTopBlueViewTopConstraint.isActive = true
        } else {
            redViewTrailingBlueViewLeadingConstraint.isActive = false
            redViewTopBlueViewTopConstraint.isActive = false
            redViewBottomBlueViewTopConstraint.isActive = true
            blueViewLeadingSafeAreaLeadingConstraint.isActive = true
            redViewTrailingSafeAreaTrailingConstraint.isActive = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeClassConstraintCoordinator()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        sizeClassConstraintCoordinator()
    }
}
