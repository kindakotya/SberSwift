//
//  NoteListViewController.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 11.11.2021.
//

import UIKit

class NoteListViewController: UIViewController {
    let notesTableView = UITableView()
    var isNeedToHideNavigationBar = true

    let noNotesLabel: UILabel = {
        let label = UILabel(text: "Notes is missing.")
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(noNotesLabel)
        view.addSubview(notesTableView)
        notesTableView.delegate = self
        notesTableView.dataSource = self
        navigationController?.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(addButtonPressed))
        notesTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteCell")
        if CoreDataService.shared.currentUser?.notes?.count == 0 {
            notesTableView.isHidden = true
        } else {
            noNotesLabel.isHidden = true
        }
        addConstraints()
    }

    func addConstraints() {
        noNotesLabel.snp.makeConstraints({make in
            make.centerWithinMargins.equalToSuperview()
        })
        notesTableView.snp.makeConstraints({make in
            make.top.equalToSuperview().inset((navigationController?.navigationBar.height ?? 0) + 16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset((navigationController?.tabBarController?.tabBar.height ?? 0) - 16)
        })
    }

    func showNavigatonBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.25, animations: {
            let constraint = self.view.constraints.first(
                where: {$0.firstAnchor == self.notesTableView.topAnchor})
            constraint?.constant = (self.navigationController?.navigationBar.height ?? 0) + 16
            self.view.layoutIfNeeded()
            self.notesTableView.layoutIfNeeded()
        })
    }

    @objc func addButtonPressed() {
        if navigationController?.navigationBar.isHidden == true {
            showNavigatonBar()
        }
        navigationController?.pushViewController(NoteDetailViewController(), animated: true)
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataService.shared.currentUser?.notes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteTableViewCell
        cell!.configureLabels(CoreDataService.shared.getNote(withIndex: indexPath.row))
        if indexPath.row == 10 && isNeedToHideNavigationBar == true {
            navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.25, animations: {
                let constraint = self.view.constraints.first(
                    where: {$0.firstAnchor == self.notesTableView.topAnchor})
                constraint?.constant = 16
                self.view.layoutIfNeeded()
                self.notesTableView.layoutIfNeeded()
            })
            isNeedToHideNavigationBar = false
        } else if indexPath.row == 0 && navigationController?.navigationBar.isHidden == true {
            showNavigatonBar()
            isNeedToHideNavigationBar = true
        }
        return cell!
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, complete in
            let notesCount = CoreDataService.shared.deleteNote(withIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            complete(true)
            if notesCount == 0 {
                tableView.isHidden = true
                self.noNotesLabel.isHidden = false
            }
        })
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigationController?.navigationBar.isHidden == true {
            showNavigatonBar()
        }
        CoreDataService.shared.editingNote = CoreDataService.shared.getNote(withIndex: indexPath.row)
        navigationController?.pushViewController(NoteDetailViewController(), animated: true)
    }
}

extension NoteListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        notesTableView.reloadData()
        if viewController is NoteListViewController {
            isNeedToHideNavigationBar = true
        }
        if CoreDataService.shared.sortedNotes.count == 0 {
            notesTableView.isHidden = true
            noNotesLabel.isHidden = false
        } else {
            notesTableView.isHidden = false
            noNotesLabel.isHidden = true
        }
    }
}
