//
//  SignInViewController.swift
//  Navigation
//
//  Created by Simon Pegg on 26.10.2022.
//

import UIKit
import SnapKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    private var email: String?
    private var password: String?
    weak var delegate: LoginViewControllerDelegate?
    
    let handle = Auth.auth().addStateDidChangeListener { auth, user in
       
    }
    
    lazy var loginLabel:UILabel = {
       let label = UILabel()
        label.text = "Your e-mail *"~
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemGray
        return label
    }()
    
    lazy var nessesLabel:UILabel = {
       let label = UILabel()
        label.text = "* Fields are neccessary to fill"~
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemGray
        return label
    }()
    
    lazy var titleLabel:UILabel = {
       let label = UILabel()
        label.text = "Sign in with e-mail"~
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var passwordLabel:UILabel = {
       let label = UILabel()
        label.text = "Create password *"~
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemGray
        return label
    }()

    lazy var loginTextField: UITextField = {
        var textfield: UITextField = UITextField(frame: .zero)
        textfield.setStyle(style: .login)
        textfield.placeholder = "Type your email"~
        textfield.addTarget(self, action: #selector(loginTextChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(passwordFieldTapped), for: .editingDidBegin)
        return textfield
    }()

    lazy var passwordTextField: UITextField = {
        var textfield: UITextField = UITextField(frame: .zero)
        textfield.setStyle(style: .login)
        textfield.placeholder = "Create password"~
        textfield.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(passwordFieldTapped), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(secureTypeOn), for: .editingDidBegin)
        return textfield
    }()
    
    lazy var signInButton: CustomButton = {
        var btn: CustomButton = CustomButton(title: "Sign in"~, titleColor: .white, onTap: self.createUserButtonTapped)
        btn.setStyle(style: .login)
        return btn
    }()
    
//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loginTextField.keyboardType = .emailAddress
    }
    
    @objc func loginTextChanged(_ textField: UITextField) {
        email = textField.text

    }

    @objc func passwordTextChanged(_ textField: UITextField) {
        password = textField.text

    }

    @objc func secureTypeOn(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }

    @objc func passwordFieldTapped(_ textField: UITextField) {

    }

    // MARK: - Setup
    
    func setupViews() {
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginLabel)
        view.addSubview(passwordLabel)
        view.addSubview(signInButton)
        view.addSubview(titleLabel)
        view.addSubview(nessesLabel)
    }
    
    func setupConstraints() {
        
        loginLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        loginTextField.snp.makeConstraints { (make) in
            make.top.equalTo(loginLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        passwordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.height.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.bounds.width)
        }
        
        nessesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-70)
            make.height.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.bounds.width - 25)
        }
    }
    
    func createUserButtonTapped() {
        guard email != nil else {
            self.present(loginAlert(), animated: true)
            print("Invalid Email NIL")
            return
        }
        
        guard password != nil else {
            self.present(loginAlert(), animated: true)
            print("Invalid Password NIL")
            return
        }
        delegate?.signUp(login: email!, password: password!, iniciator: self, realm: true)
    }
}
