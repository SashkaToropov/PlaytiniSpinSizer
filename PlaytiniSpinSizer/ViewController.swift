//
//  ViewController.swift
//  PlaytiniSpinSizer
//
//  Created by  Toropov Oleksandr on 13.03.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private var circleSize = 100.0 {
        didSet {
            if circleSize > Constants.maxCircleSize.rawValue {
                circleSize = Constants.maxCircleSize.rawValue
            } else if circleSize < Constants.minCircleSize.rawValue {
                circleSize = Constants.minCircleSize.rawValue
            }
        }
    }
    
    private var obstacleSpeed: CGFloat = 100.0
    private let obstacleHeight: CGFloat = 20.0
    
    private var collisionCount = 0
    
    private var collisionCheckTimer: Timer?
    
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
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5240610838, green: 0.5406919718, blue: 0.2848856449, alpha: 1)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        
        let action = UIAction { [weak self] _ in
            self?.increaseButtonTapped()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5240610838, green: 0.5406919718, blue: 0.2848856449, alpha: 1)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        
        let action = UIAction { [weak self] _ in
            self?.decreaseButtonTapped()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        addSubviews()
        
        setConstraints()
        
        startBallRotation()
        startObstacleMovement()
        
        collisionCheckTimer = Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { [self] _ in
            self.checkForCollisions()
        }
    }
    
    private func addSubviews() {
        view.addSubview(ballImageView)
        view.addSubview(topObstacleView)
        view.addSubview(bottomObstacleView)
        view.addSubview(increaseButton)
        view.addSubview(decreaseButton)
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
    
    private func increaseButtonTapped() {
            circleSize += 10
            updateCircleView()
            print(circleSize)
    }
    
    private func decreaseButtonTapped() {
            circleSize -= 10
            updateCircleView()
    }
    
    private func updateCircleView() {
        ballImageView.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
        ballImageView.center = view.center
        ballImageView.layer.cornerRadius = circleSize / 2
    }
    
    private func checkForCollisions() {
        guard let topObstacleFrame = topObstacleView.layer.presentation()?.frame,
              let bottomObstacleFrame = bottomObstacleView.layer.presentation()?.frame else {
            return
        }

        checkCollision(with: topObstacleFrame, for: topObstacleView)
        checkCollision(with: bottomObstacleFrame, for: bottomObstacleView)
    }

    private func checkCollision(with obstacleFrame: CGRect, for obstacleView: UIView) {
        if obstacleFrame.intersects(ballImageView.frame) {
            obstacleView.frame.origin.x = view.bounds.maxX + obstacleView.bounds.width
            collisionCount += 1
            UIDevice.vibrate()

            if collisionCount >= 5 {
                collisionCount = 0
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Зіткнення", message: "Ви зіткнулися 5 разів. Бажаєте перезапустити гру?", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Перезапустити", style: .default) { _ in
            self.resetGame()
        }
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func resetGame() {
        collisionCount = 0
        updateCircleView()
    }
}

extension ViewController {
    private func setConstraints() {
        [increaseButton, decreaseButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                increaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                increaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
                increaseButton.widthAnchor.constraint(equalToConstant: 80),
                increaseButton.heightAnchor.constraint(equalToConstant: 50),
                
                decreaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                decreaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
                decreaseButton.widthAnchor.constraint(equalToConstant: 80),
                decreaseButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
}

