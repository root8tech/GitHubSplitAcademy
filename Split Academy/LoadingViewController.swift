//
//  LoadingViewController.swift
//  Split Academy
//
//  Created by Manuel Lotti on 24/03/23.
//

import UIKit

class LoadingViewController: UIViewController {

    let backgroundImageView = UIImageView()
    let loadingIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color
                view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // Change the RGB values to the desired color
                
                // Create a label for the text
                let label = UILabel()
                label.text = "Split Academy"
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.font = UIFont.systemFont(ofSize: 24)
                
                // Add the label to the view
                view.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
    }
}


