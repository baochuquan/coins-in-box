//
//  GameViewController.swift
//  coins-in-box
//
//  Created by baochuquan on 2023/5/17.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private let shareButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.backgroundColor = .systemPink
        shareButton.frame = CGRect(x: 16, y: 50, width: UIScreen.main.bounds.size.width - 32, height: 44)
        shareButton.layer.cornerRadius = 8
        shareButton.layer.masksToBounds = true
        shareButton.setTitle("Share", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonDidPressed), for: .touchUpInside)
        view.addSubview(shareButton)


        if let view = self.view as! SKView? {
            view.backgroundColor = .white
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size
                scene.backgroundColor = .white
//                scene.anchorPoint = CGPoint(x: 0, y: 0)
                // Present the scene
                view.presentScene(scene)
                print("skview => \(view.frame)")
                print("scene => \(scene.frame)")
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    @objc
    private func shareButtonDidPressed() {
        print("Share")
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
