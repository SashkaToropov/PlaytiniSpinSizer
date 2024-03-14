//
//  ViewController.swift
//  PlaytiniSpinSizer
//
//  Created by  Toropov Oleksandr on 13.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var circleSize = 70.0
    
    private lazy var ballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
        imageView.center = view.center
        imageView.image = UIImage(named: "ball")
        imageView.layer.cornerRadius = circleSize / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ballImageView)
        
        startBallRotation()
    }
    
    private func startBallRotation() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .curveLinear]) {
            self.ballImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
}

