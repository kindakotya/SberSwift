//
//  ViewController.swift
//  traffic_lights
//
//  Created by 19657264 on 29.10.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var viewsArray: [UIView]!
    private let trafficLightsColorsArray: [UIColor] = [.red, .yellow, .green]

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for element in viewsArray {
            element.setNeedsLayout()
            element.layoutIfNeeded()
            element.layer.cornerRadius = element.frame.height / 2
        }
    }

    @IBAction func lightsSwitch(_ sender: UIButton) {
        if sender.title(for: .normal) != "Next" {
            sender.setTitle("Next", for: .normal)
            viewsArray[0].backgroundColor = .red
        } else {
            for (index, element) in viewsArray.enumerated() where element.backgroundColor != .black {
                element.backgroundColor = .black
                let nextIndex = index == 2 ? 0 : index + 1
                viewsArray[nextIndex].backgroundColor = trafficLightsColorsArray[nextIndex]
                break
            }
        }
    }
}
