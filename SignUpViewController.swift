//
//  SignUpViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/2/20.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 12
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" && passwordTextField.text == repeatPasswordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (auth, error) in
                SVProgressHUD.show(withStatus: "Checking Info")
                if error == nil {
                SVProgressHUD.showSuccess(withStatus: "Signed Up")
                self.performSegue(withIdentifier: "fromSignUpViewController", sender: nil)
                } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        SVProgressHUD.dismiss()
                    }
                }
            }
        } else {
            SVProgressHUD.showError(withStatus: "Fill out all fields")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.dismiss()
            }
        }
    }

}
