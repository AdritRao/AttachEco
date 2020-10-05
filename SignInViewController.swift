//
//  SignInViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/2/20.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        signInButton.layer.cornerRadius = 12

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (auth, error) in
            SVProgressHUD.show(withStatus: "Checking Info")
            if error == nil {
                SVProgressHUD.showSuccess(withStatus: "Signed In")
                self.performSegue(withIdentifier: "fromSignInViewController", sender: nil)
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }

}
