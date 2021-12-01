//
//  SearchListViewController.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 26.11.2021.
//

import UIKit

class SearchListViewController: UIViewController {
    let searchListTableView = UITableView()

    lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.font = .systemFont(ofSize: 20)
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.borderStyle = .roundedRect
        return textField
    }()

    lazy var goButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()

    let userNotFoundLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no user with that name on GitHub."
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemGray
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews([
                        backButton,
                        searchListTableView,
                        searchField,
                        goButton,
                        userNotFoundLabel
        ])
        addConstraints()
        searchField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        goButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func addConstraints() {
        backButton.snp.makeConstraints({make in
            make.top.equalToSuperview().inset(35)
            make.leading.equalToSuperview().inset(16)
        })
        searchField.snp.makeConstraints({make in
            make.top.equalToSuperview().inset(35)
            make.bottom.equalTo(backButton)
            make.leading.equalTo(backButton.snp_trailingMargin).inset(-16)
        })
        searchListTableView.snp.makeConstraints({make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(500)
            make.bottom.lessThanOrEqualToSuperview()
            make.top.equalTo(searchField.snp_bottomMargin).inset(-16)
        })
        goButton.snp.makeConstraints({make in
            make.top.equalToSuperview().inset(35)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(searchField)
            make.leading.equalTo(searchField.snp_trailingMargin).inset(-16)
        })
        userNotFoundLabel.snp.makeConstraints({make in
            make.top.equalTo(searchField.snp_bottomMargin)
            make.bottom.leading.trailing.equalToSuperview()
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @objc func backButtonPressed() {
        self.view.window?.switchRootViewController(to: LoginViewController(),
                                                   animated: true,
                                                   duration: 0.5,
                                                   options: .transitionFlipFromLeft, nil)
    }

    @objc func goButtonPressed() {
        NetworkService.shared.getReposArray(searchField.text ?? "")
        NetworkService.shared.condition.lock()
        while NetworkService.shared.predicate == false {
            NetworkService.shared.condition.wait()
        }
        NetworkService.shared.predicate = false
        if NetworkService.shared.reposArray.isEmpty {
            searchListTableView.reloadData()
            searchListTableView.isHidden = true
            userNotFoundLabel.isHidden = false
        } else {
            searchListTableView.reloadData()
            searchListTableView.isHidden = false
            userNotFoundLabel.isHidden = true
        }
        NetworkService.shared.condition.unlock()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue

        searchListTableView.snp.updateConstraints({make in
            make.bottom.lessThanOrEqualToSuperview().inset(keyboardFrame.height)
        })
    }

    @objc func keyboardWillHide() {
        searchListTableView.snp.updateConstraints({make in
            make.bottom.lessThanOrEqualToSuperview()
        })
    }
}

extension SearchListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goButtonPressed()
        view.endEditing(true)
        return true
    }

}

extension SearchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkService.shared.reposArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ReposTableViewCell(style: .default, reuseIdentifier: "ReposCell")
        cell.configureLabels(name: NetworkService.shared.reposArray[indexPath.row].name,
                             language: NetworkService.shared.reposArray[indexPath.row].language,
                             URL: NetworkService.shared.reposArray[indexPath.row].cloneURL)
        return cell
    }
}
