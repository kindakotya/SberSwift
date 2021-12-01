//
//  NoteTableViewCell.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 12.11.2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 3
        label.textAlignment = .justified
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "NoteCell")
        addSubview(noteLabel)
        addSubview(dateLabel)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLabels(_ note: Note?) {
        guard note != nil else {return}
        noteLabel.text = note!.text
        dateLabel.text = note!.creationDate?.dateString()
    }

    func addConstraints() {
        noteLabel.snp.makeConstraints({make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualTo(dateLabel.snp_topMargin)
        })
        dateLabel.snp.makeConstraints({make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(snp_bottomMargin).inset(-dateLabel.requiredHeight).priority(500)
        })
    }
}
