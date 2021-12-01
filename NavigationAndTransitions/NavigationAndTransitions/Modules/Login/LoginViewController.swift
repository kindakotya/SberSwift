//
//  LoginViewController.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 09.11.2021.
//

import UIKit

class LoginViewController: UIViewController {

    let authorizationStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Const.Constraints.stackViewSpacing
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Const.Constraints.stackViewSpacing
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    let authorizationLabel: UILabel = {
        let label = UILabel()
        label.font = Const.Fonts.labelsAndButtons
        label.text = Const.Text.autorizationLabel
        label.textAlignment = .center
        return label
    }()

    let alarmLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Const.Text.loginButton, for: .normal)
        button.titleLabel?.font = Const.Fonts.labelsAndButtons
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Const.Text.searchButton, for: .normal)
        button.titleLabel?.font = Const.Fonts.labelsAndButtons
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Const.Fonts.labelsAndButtons
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(Const.Text.registerButton, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.Text.usernameTextFieldPlaceholder
        textField.font = Const.Fonts.textFields
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.font = passwordTextField.font
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(buttonsControl), for: .editingChanged)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.Text.passwordTextFieldPlaceholder
        textField.adjustsFontSizeToFitWidth = true
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        return textField
    }()

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Const.Text.VCTitle
        view.backgroundColor = .systemBackground
        view.addSubview(searchButton)
        view.addSubview(authorizationStackView)
        authorizationStackView.addArrangedSubviews([authorizationLabel,
                                                    usernameTextField,
                                                    passwordTextField,
                                                    buttonsStackView])
        loginButton.titleLabel?.font = registerButton.titleLabel?.font
        passwordTextField.delegate = self
        view.addSubview(alarmLabel)
        addConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        authorizationStackView.snp.updateConstraints({make in
            make.trailing.equalToSuperview().inset(1 / 4 * size.width)
            make.leading.equalToSuperview().inset(1 / 4 * size.width)
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    func addConstraints() {
        searchButton.snp.makeConstraints({make in
            make.top.trailing.equalToSuperview().inset(Const.Constraints.searchButtonTopTrailingInset)
        })
        alarmLabel.snp.makeConstraints({make in
            make.trailing.leading.equalTo(authorizationStackView)
            make.top.equalTo(authorizationStackView.snp_bottomMargin)
        })
        buttonsStackView.addArrangedSubviews([loginButton, registerButton])
        authorizationStackView.snp.makeConstraints({make in
            make.trailing.equalToSuperview().inset(1 / 4 * view.frame.width)
            make.leading.equalToSuperview().inset(1 / 4 * view.frame.width)
            make.centerY.equalToSuperview().priority(Const.Constraints.stackViewCenterYPtiority)
            make.bottom.lessThanOrEqualToSuperview()
            make.top.greaterThanOrEqualToSuperview()
        })
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardShowDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
        UIView.animate(withDuration: keyboardShowDuration ?? Const.AnimationDurations.showKeyboard, animations: {
            let constraint = self.view.constraints.first(
                    where: {$0.firstAnchor == self.authorizationStackView.bottomAnchor})
            constraint?.constant = -keyboardFrame.height
            self.view.layoutIfNeeded()
            self.authorizationStackView.layoutIfNeeded()
            })
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardShowDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardShowDuration ?? Const.AnimationDurations.showKeyboard, animations: {
            let constraint = self.view.constraints.first(
                where: {$0.firstAnchor == self.authorizationStackView.bottomAnchor})
            constraint?.constant = 0
            self.view.layoutIfNeeded()
            self.authorizationStackView.layoutIfNeeded()
            })
    }

    @objc func buttonsControl() {
        if usernameTextField.isEmpty {
            loginButton.isEnabled = false
            registerButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
            registerButton.isEnabled = true
        }
    }

    @objc func loginButtonPressed() {
        if CoreDataService.shared.setCurrentUser(withName: usernameTextField.text!,
                                                 withPassword: passwordTextField.text!) {
            self.view.window?.switchRootViewController(to: TabBarController(),
                                                       animated: true,
                                                       duration: Const.AnimationDurations.switchViewController,
                                                       options: .transitionFlipFromRight, nil)
        }
        alarmLabel.text = Const.AlarmLabelText.incorrectParams
        alarmLabel.textColor = .systemRed
        alarmLabel.isHidden = false
        view.endEditing(true)
    }

    @objc func registerButtonPressed() {
        guard usernameTextField.text != "" else {return}
        loginButtonPressed()
        view.endEditing(true)
        guard CoreDataService.shared.addUser(withName: usernameTextField.text!, withPassword: passwordTextField.text!)
        else {
            alarmLabel.text = "User with login \(usernameTextField.text!) is already exist."
            alarmLabel.textColor = .systemRed
            alarmLabel.isHidden = false
            return
        }
        alarmLabel.text = Const.AlarmLabelText.registerOK
        alarmLabel.textColor = .systemGreen
        alarmLabel.isHidden = false
    }

    @objc func searchButtonPressed() {
        self.view.window?.switchRootViewController(to: SearchListViewController(),
                                                   animated: true,
                                                   duration: Const.AnimationDurations.switchViewController,
                                                   options: .transitionFlipFromRight, nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next:
            passwordTextField.becomeFirstResponder()
        default:
            view.endEditing(true)
            if usernameTextField.text.isNilOrEmpty {
                alarmLabel.text = Const.AlarmLabelText.blankLogin
                alarmLabel.textColor = .systemRed
                alarmLabel.isHidden = false
            } else {
                loginButtonPressed()
            }
        }
        return false
    }
}

fileprivate enum Const {

    enum Constraints {
        static let searchButtonTopTrailingInset: CGFloat = 16.0
        static let stackViewSpacing: CGFloat = 16.0
        static let stackViewCenterYPtiority = 500
    }
    enum Fonts {
        static let labelsAndButtons = UIFont.systemFont(ofSize: 25)
        static let textFields = UIFont.systemFont(ofSize: 20)
    }
    enum Text {
        static let autorizationLabel = "Authorization"
        static let loginButton = "Login"
        static let VCTitle = "Login"
        static let searchButton = "Search"
        static let registerButton = "Register"
        static let usernameTextFieldPlaceholder = "Username"
        static let passwordTextFieldPlaceholder = "Password (optional)"
    }
    enum AnimationDurations {
        static let switchViewController = 0.5
        static let showKeyboard = 0.25
    }
    enum AlarmLabelText {
        static let incorrectParams = "Incorrect login or password."
        static let registerOK = "Registration susseful!"
        static let blankLogin = "Login text field can't be blank."
    }
}
