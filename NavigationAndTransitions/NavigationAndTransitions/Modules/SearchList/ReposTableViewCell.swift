//
//  ReposTableViewCell.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 29.11.2021.
//

import UIKit

class ReposTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 25)
        return label
    }()

    let languageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .right
        return label
    }()

    let URLLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "RepoCell")
        addSubviews([nameLabel,
                     languageLabel,
                     URLLabel])
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addConstraints() {
        nameLabel.snp.makeConstraints({make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview()
            make.trailing.lessThanOrEqualTo(languageLabel.snp_leadingMargin)
            make.bottom.lessThanOrEqualTo(URLLabel.snp_topMargin)
        })
        languageLabel.snp.makeConstraints({make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        })
        URLLabel.snp.makeConstraints({make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        })
    }

    func configureLabels(name: String?, language: String?, URL: String?) {
        nameLabel.text = name
        languageLabel.text = language
        URLLabel.text = URL
        setNeedsLayout()
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

}
