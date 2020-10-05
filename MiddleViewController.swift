//
//  MiddleViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/3/20.
//

import UIKit

class MiddleViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cornerRadius(button: button4)
        cornerRadius(button: button1)
        cornerRadius(button: button2)
        cornerRadius(button: button3)
    }
    
    func cornerRadius(button: UIButton) {
        button.layer.cornerRadius = 12
    }


}
