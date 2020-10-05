//
//  StartViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/1/20.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
        
        signInButton.setTitle("Sign In", for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        
        signInButton.setTitleColor(UIColor.white, for: .normal)
//        signUpButton.setTitleColor(UIColor(red: 72, green: 147, blue: 89, alpha: 1), for: .normal)
//        signUpButton.setTitleColor(UIColor.green, for: .normal)
        
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.lightGray.cgColor
//        signUpButton.layer.borderColor = CGColor(red: 72, green: 147, blue: 89, alpha: 1)
    
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {

    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
    }

}
