//
//  LoginViewController.swift
//  Storify
//
//  Created by Work on 2/12/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var rootVcReference : FeedViewController?
    var imageSelected: Bool?
    var activityIndicator: UIActivityIndicatorView!
    
    lazy var loginConatinerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.clear
        cView.layer.cornerRadius = 5
        cView.layer.masksToBounds = true
        cView.translatesAutoresizingMaskIntoConstraints = false
        
        return cView
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 0.9824436415, blue: 0.9833538921, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.layer.cornerRadius = 20
        button.backgroundColor?.withAlphaComponent(0.7)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(handleUserLoginRegister), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc func handleUserLoginRegister(){
        setupActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.loginRegisterButton.isEnabled = false
        self.loginConatinerView.isOpaque = false
        self.loginConatinerView.alpha = 0.1
       // self.activityIndicator.startAnimating()
        
        if(loginResgisterSegmentedControl.selectedSegmentIndex == 0){
            loginUser()
        }else{
            registerUser()
        }
    }
    
    private func loginUser(){
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Empty Fields", message: "Username or password is not entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.view.isHidden = true
                self.loginConatinerView.alpha = 1
                self.loginConatinerView.isOpaque = true
               // self.activityIndicator.stopAnimating()
                self.loginRegisterButton.isEnabled = true
               // self.activityIndicator.stopAnimating()
            }))
            emailTextField.text = ""
            passwordTextField.text = ""
            present(alert, animated: true, completion: nil)
            return
        }
        guard let email = emailTextField.text , let password = passwordTextField.text else{
            return
        }
        self.activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (User, error) in
            if(error != nil){
                let alert = UIAlertController(title: "Empty Fields", message: "Username or password is incorrect", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.loginConatinerView.alpha = 1
                    self.loginConatinerView.isOpaque = false
                    self.activityIndicator.stopAnimating()
                    self.loginRegisterButton.isEnabled = true
                    alert.view.isHidden = true
                }))
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.activityIndicator.stopAnimating()
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.rootVcReference?.setNaviagtionItemTitleForCurrentUser()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @objc func enumerateLoginRegitersSegmentedViews(){
       let title = self.loginResgisterSegmentedControl.titleForSegment(at: self.loginResgisterSegmentedControl.selectedSegmentIndex)
        UIView.transition(with: loginRegisterButton.titleLabel!, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.loginRegisterButton.setTitle(title, for: .normal)
        }, completion: nil)
        
        // Mark -> changing height for input container according to segmented control
        inputContainerViewHeightAnchorConstraint?.constant = loginResgisterSegmentedControl.selectedSegmentIndex == 0 ? 110 : 160
        
        // Mark -> changing height for Name TextField according to segmented control
        nameTextFieldHeightAnchorConstraint?.isActive = false
        nameTextFieldHeightAnchorConstraint = nameTextField.heightAnchor.constraint(equalToConstant: loginResgisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 50)
       
        nameTextFieldHeightAnchorConstraint?.isActive = true
        
        // Mark -> changing height for Email TextField according to segmented control
        emailTextFieldHeightAnchorConstraint?.isActive = false
        emailTextFieldHeightAnchorConstraint = emailTextField.heightAnchor.constraint(equalToConstant: loginResgisterSegmentedControl.selectedSegmentIndex == 0 ? 50 : 50)
        emailTextFieldHeightAnchorConstraint?.isActive = true
        
        // Mark -> changing height for Password TextField according to segmented control
        passwordTextFieldHeightAnchorConstraint?.isActive = false
        passwordTextFieldHeightAnchorConstraint = passwordTextField.heightAnchor.constraint(equalToConstant: loginResgisterSegmentedControl.selectedSegmentIndex == 0 ? 50 : 50)
        passwordTextFieldHeightAnchorConstraint?.isActive = true
        
    }
    
    
    
    let nameTextField: UITextField = {
        let textField = TextField()
        textField.backgroundColor = UIColor.clear
         textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20.0)
            ])
      //  textField.typingAttributes =
        textField.font = .boldSystemFont(ofSize: 20.0)
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 25.0
        
        textField.layer.borderColor = UIColor.white.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let emailTextField: UITextField = {
        let textField = TextField()
         textField.font = .boldSystemFont(ofSize: 20.0)
        textField.textColor = UIColor.white
        textField.backgroundColor = UIColor.clear
         textField.layer.cornerRadius = 25.0
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20.0)
            ])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    let passwordTextField: UITextField = {
        let textField = TextField()
         textField.font = .boldSystemFont(ofSize: 20.0)
         textField.textColor = UIColor.white
        textField.backgroundColor = UIColor.clear
         textField.layer.cornerRadius = 25.0
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20.0)
            ])
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var daily3Logo: UIImageView = {
        let imageVIew = UIImageView()
        imageVIew.image = UIImage(named: "logoTitle")
        //imageVIew.backgroundColor = UIColor.black
        imageVIew.translatesAutoresizingMaskIntoConstraints = false
        //imageVIew.layer.cornerRadius = 70
        imageVIew.layer.masksToBounds = true
        imageVIew.contentMode = .scaleAspectFit
        return imageVIew
    }()
    
    lazy var loginResgisterSegmentedControl: UISegmentedControl = {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
        sc.selectedSegmentIndex = 1
        sc.tintColor = UIColor.white
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(enumerateLoginRegitersSegmentedViews), for: .valueChanged)
        return sc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLoginView()
        self.nameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var inputContainerViewHeightAnchorConstraint : NSLayoutConstraint?
    var nameTextFieldHeightAnchorConstraint : NSLayoutConstraint?
    var emailTextFieldHeightAnchorConstraint : NSLayoutConstraint?
    var passwordTextFieldHeightAnchorConstraint : NSLayoutConstraint?
    
    
    fileprivate func setupConstraintsOfInputContainer() {
        
        //MARK-> INPUTS CONTAINER
        //  Define x,y,width,height for input container
        loginConatinerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginConatinerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginConatinerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        inputContainerViewHeightAnchorConstraint = loginConatinerView.heightAnchor.constraint(equalToConstant: 160)
        inputContainerViewHeightAnchorConstraint?.isActive = true
        
        //MARK-> NAME TEXTFIELD
        // Define x,y,width,height for Name textfield
        loginConatinerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: loginConatinerView.leftAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: loginConatinerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: loginConatinerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchorConstraint = nameTextField.heightAnchor.constraint(equalToConstant: 50)
        nameTextFieldHeightAnchorConstraint?.isActive = true
        
        
        //MARK-> NAME TEXTFIELD SEPERATOR LINE
        // Define x,y,width,height for name Seperator line
       /* loginConatinerView.addSubview(nameSeperatorLine)
        nameSeperatorLine.widthAnchor.constraint(equalTo: loginConatinerView.widthAnchor).isActive = true
        nameSeperatorLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        nameSeperatorLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorLine.leftAnchor.constraint(equalTo: loginConatinerView.leftAnchor).isActive = true*/
        
        //MARK-> EMAIL TEXTFIELD
        // Define x,y,width,height for EMAIL Textfield
        
        loginConatinerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: loginConatinerView.leftAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: loginConatinerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchorConstraint = emailTextField.heightAnchor.constraint(equalToConstant: 50)
        emailTextFieldHeightAnchorConstraint?.isActive = true
        
        // MARK-> EMAIL TEXTFIELD SEPERATOR LINE
        
      /*  loginConatinerView.addSubview(emailSeperator)
        emailSeperator.widthAnchor.constraint(equalTo: loginConatinerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperator.leftAnchor.constraint(equalTo: loginConatinerView.leftAnchor).isActive = true*/
        
        //MARK-> Password TEXTFIELD
        // Define x,y,width,height for EMAIL Textfield
        loginConatinerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: loginConatinerView.leftAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: loginConatinerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchorConstraint = passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        passwordTextFieldHeightAnchorConstraint?.isActive = true
        
        
    }
    
    fileprivate func setupConstraintsOfRegitserButton() {
        // define x,y,width,height
        
        loginRegisterButton.widthAnchor.constraint(equalTo: loginConatinerView.widthAnchor, constant: -100).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: loginConatinerView.bottomAnchor, constant: 12).isActive = true
    }
    
    
    fileprivate func setupLogoImageViewConstraints() {
        daily3Logo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        daily3Logo.bottomAnchor.constraint(equalTo: loginResgisterSegmentedControl.topAnchor, constant: -20).isActive = true
        daily3Logo.widthAnchor.constraint(equalToConstant: 280).isActive = true
        daily3Logo.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    fileprivate func setupLoginRegisterSegmentedControlConstraints() {
        loginResgisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginResgisterSegmentedControl.bottomAnchor.constraint(equalTo: loginConatinerView.topAnchor, constant: -12).isActive = true
        loginResgisterSegmentedControl.widthAnchor.constraint(equalTo: loginConatinerView.widthAnchor).isActive = true
        loginResgisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private func setupLoginView(){
        
        // Background color
       //loginRegisterViewBackgroundLayer.frame = self.view.bounds
       //view.layer.addSublayer(loginRegisterViewBackgroundLayer)
        view.applyMainAppTheme()
        
        view.addSubview(loginConatinerView)
        setupConstraintsOfInputContainer()
        
        view.addSubview(loginRegisterButton)
        setupConstraintsOfRegitserButton()
      
        
        view.addSubview(loginResgisterSegmentedControl)
        setupLoginRegisterSegmentedControlConstraints()
        
        view.addSubview(daily3Logo)
        setupLogoImageViewConstraints()
        
    }
    
    private func setupActivityIndicator(){
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.activityIndicator.center = self.view.center
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    lazy var loginRegisterViewBackgroundLayer: CAGradientLayer = {
        var gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#D585FF"),hexStringToCGColor(hex: "#00FFEE")]
        return gradientLayer
    }()
    
    lazy var loginRegisterButtonBagroundLayer: CAGradientLayer = {
        var gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#3A3897"),hexStringToCGColor(hex: "#A3A1FF")]
        return gradientLayer
    }()
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            )
    }
    
  
    func hexStringToCGColor (hex:String) -> CGColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray.cgColor
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        ).cgColor
    }
    
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}



