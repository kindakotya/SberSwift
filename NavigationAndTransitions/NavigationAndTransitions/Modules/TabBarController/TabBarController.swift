//
//  TabBarController.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 16.11.2021.
//

import UIKit

class TabBarController: UITabBarController {
    lazy var welcomeViewController: WelcomeViewController = WelcomeViewController()
    lazy var noteListNavigationController = UINavigationController(rootViewController: NoteListViewController())
    let homeImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "home.png", ofType: nil) ?? "")
    let noteImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "paper-message.png", ofType: nil) ?? "")

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeViewController.title = "Welcome"
        noteListNavigationController.title = "Notes"
        setViewControllers([welcomeViewController, noteListNavigationController], animated: false)
        welcomeViewController.tabBarItem = UITabBarItem(title: "Welcome", image: homeImage, selectedImage: homeImage)
        noteListNavigationController.tabBarItem = UITabBarItem(title: "Notes",
                                                               image: noteImage, selectedImage: noteImage)
    }
}
