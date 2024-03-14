//
//  ViewController.swift
//  PlaytiniSpinSizer
//
//  Created by  Toropov Oleksandr on 13.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var circleSize = 70.0
    
    private var obstacleSpeed: CGFloat = 100.0
    private let obstacleHeight: CGFloat = 20.0
    
    private lazy var ballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
        imageView.center = view.center
        imageView.image = UIImage(named: "ball")
        imageView.layer.cornerRadius = circleSize / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var topObstacleView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: view.bounds.maxX, y: 0, width: 150, height: obstacleHeight))
        view.image = UIImage(named: "obstacle")
        return view
    }()
    
    private lazy var bottomObstacleView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: view.bounds.maxX, y: view.bounds.maxY - obstacleHeight, width: 150, height: obstacleHeight))
        view.image = UIImage(named: "obstacle")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ballImageView)
        view.addSubview(topObstacleView)
        view.addSubview(bottomObstacleView)
        
        view.backgroundColor = .darkGray
        startBallRotation()
        startObstacleMovement()
    }
    
    private func startBallRotation() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .curveLinear]) {
            self.ballImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    private func startObstacleMovement() {
        topObstacleView.frame.origin.x = view.bounds.maxX
        bottomObstacleView.frame.origin.x = view.bounds.maxX
        
        let topObstacleY = CGFloat.random(in: obstacleHeight...(view.bounds.height / 2 - obstacleHeight))
        let bottomObstacleY = CGFloat.random(in: (view.bounds.height / 2 + obstacleHeight)...(view.bounds.height - obstacleHeight))
        
        topObstacleView.frame.origin.y = topObstacleY
        bottomObstacleView.frame.origin.y = bottomObstacleY
        
        let moveObstacleAnimation = UIViewPropertyAnimator(duration: Double(view.bounds.width / obstacleSpeed), curve: .linear) {
            self.topObstacleView.frame.origin.x = -self.topObstacleView.bounds.width
            self.bottomObstacleView.frame.origin.x = -self.bottomObstacleView.bounds.width
        }
        
        moveObstacleAnimation.addCompletion { [self] _ in
            self.startObstacleMovement()
        }
        
        moveObstacleAnimation.startAnimation()
    }
}

