//
//  LoginViewController.swift
//  PureMind
//
//  Created by Клим on 10.07.2021.
//

import UIKit

protocol LoginViewProtocol: UIViewController{
    func updateUI()
    func loginAlert(text: String)
    func loginSuccess()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var assistButtonOutlet: UIButton!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var loginGoogleButtonOutlet: UIButton!
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [UIColor(red: 239, green: 243, blue: 255),
        UIColor(red: 255, green: 252, blue: 250)]
        gradient.locations = [0, 0.25, 1]
        return gradient
    }()
    var passwordHidden = true
    var presenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        prepareViews()
        prepareButtons()
        prepareTextFields()
        emailTextField.text = "lol@kek.com"
        passwordTextField.text = "123456"
    }
    
    @objc func handleGesture(){
        navigationController?.popViewController(animated: true)
    }
    
    func transformTextField(myTextField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 25 - 1, width: 265, height: 1.0)
        bottomLine.backgroundColor = lightTextColor.cgColor
        myTextField.borderStyle = UITextField.BorderStyle.none
        myTextField.layer.addSublayer(bottomLine)
    }
    
    func prepareButtons(){
        assistButtonOutlet.setTitleColor(policiesButtonColor, for: .normal)
        
        loginButtonOutlet.backgroundColor = newButtonLabelColor
        loginButtonOutlet.layer.cornerRadius = 15
        
        loginGoogleButtonOutlet.layer.cornerRadius = 15
        loginGoogleButtonOutlet.backgroundColor = .clear
        loginGoogleButtonOutlet.layer.borderWidth = 2
        loginGoogleButtonOutlet.setTitleColor(grayButtonColor, for: .normal)
        loginGoogleButtonOutlet.layer.borderColor = lightYellowColor.cgColor
        
    }
    
    func prepareViews(){
        loginView.layer.cornerRadius = 28
        loginView.backgroundColor = .white
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor(red: 178, green: 186, blue: 230).cgColor
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        titleLabel.textColor = newButtonLabelColor
        emailLabel.textColor = newButtonLabelColor
        passwordLabel.textColor = newButtonLabelColor
        forgotPasswordLabel.textColor = newButtonLabelColor
    }
    
    func prepareTextFields(){
        emailTextField.delegate = self
        emailTextField.textColor = lightTextColor
        transformTextField(myTextField: emailTextField)
        passwordTextField.delegate = self
        passwordTextField.textColor = lightTextColor
        transformTextField(myTextField: passwordTextField)
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let message = presenter.infoValidation(email: emailTextField.text!, password: passwordTextField.text!)
        if message == "pass"{
            presenter.performLogin(email: emailTextField.text!, password: passwordTextField.text!)
            
        }
        else{
            //validationAlert(message: message)
        }
        presenter.performLogin(email: emailTextField.text!, password: passwordTextField.text!)

    }
    
    @IBAction func passwordVisiblePressed(_ sender: UIButton) {
        if passwordHidden == true{
            passwordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(named: "eye_closed"), for: .normal)
        }
        else{
            passwordTextField.isSecureTextEntry = true
            sender.setImage(UIImage(named: "custom_eye"), for: .normal)
        }
        passwordHidden = !passwordHidden
    }
    
    
    
    @IBAction func googleButtonPressed(_ sender: Any) {
    }
    
    @IBAction func assistButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "restorePasswordSegue", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func validationAlert(message: String){
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Oк", style: .cancel, handler: nil)
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController: LoginViewProtocol{
    func updateUI() {
        print("Good!")
    }
    
    func loginAlert(text: String){
        validationAlert(message: text)
    }
    
    func loginSuccess(){
        performSegue(withIdentifier: "loginToMenuSegue", sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 35
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
