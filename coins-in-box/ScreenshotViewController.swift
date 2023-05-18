//
//  ScreenshotViewController.swift
//  coins-in-box
//
//  Created by baochuquan on 2023/5/18.
//

import Foundation
import UIKit

class ScreenshotViewController: UIViewController {
    private let screenshot: UIImage
    private lazy var shareImageView = {
        let view = UIImageView(image: screenshot)
        return view
    }()

    init(with screenshot: UIImage) {
        self.screenshot = screenshot
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        view.addSubview(shareImageView)
        let size = screenshot.size
        let x = (UIScreen.main.bounds.width - size.width) * 0.5
        let y = (UIScreen.main.bounds.height - size.height) * 0.5
        shareImageView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
