//
//  NoteDetailViewController.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 12.11.2021.
//

import UIKit

class NoteDetailViewController: UIViewController {

    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.text = CoreDataService.shared.editingNote?.text ?? ""
        textView.font = .systemFont(ofSize: 20)
        textView.textAlignment = .justified
        return textView
    }()

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(noteTextView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem?.isEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        noteTextView.snp.makeConstraints({make in
            make.top.equalToSuperview().inset((navigationController?.navigationBar.height ?? 0) + 16)
            make.trailing.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16).priority(500)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        })
    }

    @objc func saveButtonPressed() {
        if CoreDataService.shared.editingNote == nil {
            CoreDataService.shared.addNote(withText: noteTextView.text)
        } else {
            CoreDataService.shared.editNote(newText: noteTextView.text)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue

        noteTextView.snp.updateConstraints({make in
            make.bottom.lessThanOrEqualToSuperview().inset(keyboardFrame.height)
        })
    }

    @objc func keyboardWillHide() {
        noteTextView.snp.updateConstraints({make in
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
