//
//  RegistrationController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/30/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import  Firebase
import JGProgressHUD

class RegistrationController :UIViewController{
    //MARK: Properties
    let gradient = CAGradientLayer()
    let registrationViewModel = RegistrationViewModel()
    
    private let selectedButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
        
    }()
    
    private let nameTextField : CustomTextField = {
        let tf = UITextField().createTextfield(withPlaceholder: "Enter Full Name")
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    
    private let emailTextField : CustomTextField = {
        let tf = UITextField().createTextfield(withPlaceholder: "Enter Email Name")
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField : CustomTextField = {
        let tf = UITextField().createTextfield(withPlaceholder: "Enter Full Name",isSecure: true)
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    
    private let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        //        button.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameTextField, emailTextField,
                                                passwordTextField,registerButton])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [selectedButton,verticalStackView])
    
    let goLoginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: Life Cycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationObserver()
        setupTapGesture()
        setupRegistrationViewModelObserver()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradient.frame = view.bounds
        
    }
    
    
    //MARK: Selector
    
    @objc func handleGoLogin(){
        
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    @objc func handleSelectPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    let registerHUD = JGProgressHUD(style: .dark)
    
    @objc func handleRegister(){
        handleTapOnView()
        registrationViewModel.performRegistration { [weak self](error) in
            if let error = error{
                self?.showHUDWithError(error: error)
            }
            
            print("finished registering")
        }
        
        
    }
    
    @objc func handleTextChanged(textfield : UITextField){
        
        if textfield == nameTextField{
            
            registrationViewModel.fullName = nameTextField.text
        }
        else if textfield == emailTextField{
            registrationViewModel.email = emailTextField.text
        }
        else {
            registrationViewModel.password = passwordTextField.text
        }
    }
    @objc func handleTapOnView(){
        view.endEditing(true)
        
    }
    
    @objc func handleKeyboardHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    @objc fileprivate func handleKeyboardShow(notification : Notification){
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
        }
    }
    
    //MARK: Helper Function
    
    fileprivate func showHUDWithError(error: Error){
        registerHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed to register"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    fileprivate func setupRegistrationViewModelObserver(){
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self](isFormValid) in
            
            guard let isFormValid = isFormValid else {return}
            self.registerButton.isEnabled = isFormValid
            if isFormValid{
                
                self.registerButton.setTitleColor(.white, for: .normal)
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            }
            else{
                self.registerButton.setTitleColor(.gray, for: .normal)
                self.registerButton.backgroundColor = .lightGray
            }
        }
        registrationViewModel.bindableImage.bind { [weak self](image) in
            self?.selectedButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true{
                self.registerHUD.textLabel.text = "Register"
                self.registerHUD.show(in: self.view)
            }
            else{
                self.registerHUD.dismiss()
            }
        }
    }
    
    fileprivate func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        view.addGestureRecognizer(tap)
    }
    fileprivate func setupNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupGradientLayer(){
        
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
    }
    
    
    fileprivate func setupLayout() {
        
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        selectedButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        view.addSubview(overallStackView)
        overallStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 50,paddingRight: 50)
        overallStackView.centerY(inView: self.view)
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(goLoginButton)
        goLoginButton.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,
                             paddingLeft: 20,paddingBottom: 20,paddingRight: 20)
    }
}


extension RegistrationController{
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact{
            overallStackView.axis = .horizontal
        }else{
            overallStackView.axis = .vertical
        }
    }
    
}

extension RegistrationController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        registrationViewModel.bindableImage.value = image
        registrationViewModel.formValidity()
        
        self.dismiss(animated: true, completion: nil)
        
    }
}


//        registrationViewModel.isFormValidObserver = { [unowned self](isFormValid) in
//
//            self.registerButton.isEnabled = isFormValid
//            if isFormValid{
//
//                self.registerButton.setTitleColor(.white, for: .normal)
//                self.registerButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//            }
//            else{
//                self.registerButton.setTitleColor(.gray, for: .normal)
//                self.registerButton.backgroundColor = .lightGray
//            }
//        }
