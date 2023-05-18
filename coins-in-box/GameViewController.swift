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
    private let scene = SKScene(fileNamed: "GameScene")
    private let sceneView = SKView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView)
        sceneView.frame = view.bounds

        shareButton.backgroundColor = .systemPink
        shareButton.frame = CGRect(x: 16, y: 50, width: UIScreen.main.bounds.size.width - 32, height: 44)
        shareButton.layer.cornerRadius = 8
        shareButton.layer.masksToBounds = true
        shareButton.setTitle("Share", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonDidPressed), for: .touchUpInside)
        view.addSubview(shareButton)

        // Load the SKScene from 'GameScene.sks'
        if let scene = scene {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.size = view.bounds.size
            scene.backgroundColor = .white
            // Present the scene
            sceneView.presentScene(scene)
        }

        sceneView.backgroundColor = .white
        sceneView.ignoresSiblingOrder = true
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
//            view.showsPhysics = true
    }

    func getScreenshot(scene: SKScene) -> UIImage? {
        let snapshotView = scene.view!.snapshotView(afterScreenUpdates: true)
        let bounds = UIScreen.main.bounds

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)

        snapshotView?.drawHierarchy(in: bounds, afterScreenUpdates: true)

        let screenshotImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return screenshotImage
    }

    @objc
    private func shareButtonDidPressed() {
        print("Share")
        let vc = ScreenshotViewController(with: sceneView.captureScreen)
        present(vc, animated: true)
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

extension UIView {
    var screenshotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        guard let context = UIGraphicsGetCurrentContext() else { return image }
        layer.render(in: context)
        image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

    var captureScreen: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)

        drawHierarchy(in: bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
