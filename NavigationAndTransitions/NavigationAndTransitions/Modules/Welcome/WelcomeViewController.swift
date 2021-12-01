//
//  WelcomeViewController.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 10.11.2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome, \(CoreDataService.shared.currentUser?.login ?? "stranger")!"
        label.font = .systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let lastNoteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()

    let lastNoteCreationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        if CoreDataService.shared.currentUser?.notes?.count != 0 {
            let dateString = DateFormatter
                .localizedString(from: CoreDataService.shared.getLastNote().creationDate!,
                                 dateStyle: .medium, timeStyle: .medium)
            label.text = "Created in \(dateString)"
        }
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(logoutButton)
        view.addSubview(welcomeLabel)
        view.addSubview(lastNoteLabel)
        view.addSubview(lastNoteCreationDateLabel)
        addConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        if CoreDataService.shared.currentUser?.notes?.count == 0 {
            lastNoteLabel.text = "There is no last note no show."
        } else {
            lastNoteLabel.text =
            "Last note before login:\n\n\(String(describing: CoreDataService.shared.getLastNote().text!))"
        }
    }

    func addConstraints() {
        logoutButton.snp.makeConstraints({make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(35)
        })
        welcomeLabel.snp.makeConstraints({make in
            make.top.equalTo(logoutButton.snp_bottomMargin).inset(20)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.equalTo(100)
        })
        lastNoteLabel.snp.makeConstraints({make in
            make.top.equalTo(welcomeLabel.snp_bottomMargin).inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(lastNoteCreationDateLabel.snp_topMargin).inset(16)
        })
        lastNoteCreationDateLabel.snp.makeConstraints({make in
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.height ?? 0 + 35)
            make.height.equalTo(100)
        })
    }

    @objc func logoutButtonPressed() {
        self.view.window?.switchRootViewController(to: LoginViewController(),
                                                   animated: true,
                                                   duration: 0.5,
                                                   options: .transitionFlipFromLeft, nil)
    }
}
