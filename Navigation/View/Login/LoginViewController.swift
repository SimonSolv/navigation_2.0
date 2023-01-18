import SnapKit
import UIKit
import Firebase
import GoogleSignIn
import RealmSwift



class LoginViewController: UIViewController, Coordinated {
    
    var inspector = LoginInspector()
    static let identifier = "Log In"
    let signInConfig = GIDConfiguration.init(clientID: "822406758404-fev69ian0g95hb9jcgve9pisak35s5bl.apps.googleusercontent.com")
    var myUser = UserInfo()
    var googleSignIn = GIDSignIn.sharedInstance
    var coordinator: CoordinatorProtocol?
    private var userName: String?
    private var userPassword: String?
    lazy var contentView = UIScrollView()
    var brudPass = ""
    let realm = try! Realm()
    var users: Results<Credentials>?
    let handle = Auth.auth().addStateDidChangeListener { auth, user in
            // ...
    }
    

//MARK: Views
    lazy var signInLineButton: CustomButton = {
        let label = CustomButton(title: "Sign in with e-mail"~, titleColor: .systemBlue, onTap: self.signInButtonTapped)
        return label
    }()
    
    lazy var googleSignInButton = GIDSignInButton()
    
    lazy var passwordToUnlock: String = ""

    lazy var logoImageView: UIView = {
        let image: UIImageView = UIImageView()
        image.image = UIImage(named: "VKlogo")
        image.sizeToFit()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var loginButton: CustomButton = {
        var btn: CustomButton = CustomButton(title: "Log in"~, titleColor: .white, onTap: self.loginButtonTapped)
        btn.setStyle(style: .login)
        return btn
    }()
    
    lazy var createPasswordButton: CustomButton = {
        var btn: CustomButton = CustomButton(title: "Hack password"~, titleColor: .white, onTap: self.createPasswordButtonTapped)
        btn.setStyle(style: .login)
        return btn
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        return view
    }()

    lazy var loginTextField: UITextField = {
        var textfield: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        textfield.setStyle(style: .login)
        textfield.placeholder = "Email or phone"~
        textfield.addTarget(self, action: #selector(loginTextChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(passwordFieldTapped), for: .editingDidBegin)
        return textfield
    }()

    lazy var passwordTextField: UITextField = {
        var textfield: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        textfield.setStyle(style: .login)
        textfield.placeholder = "Password"~
        textfield.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(passwordFieldTapped), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(secureTypeOn), for: .editingDidBegin)
        return textfield
    }()

    lazy var inputSourceView: UIStackView = {
        var view = UIStackView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.axis = .vertical
        return view
    }()

    lazy var wrongPswdView: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Incorrect login or password"~
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    func unvealdPassword(password: String) {
        self.passwordTextField.isSecureTextEntry = false
        self.passwordTextField.text = password
    }
    
    func activityIndicatorHandler(state: Bool) {
        switch state {
        case true:
            self.indicatorView.startAnimating()
            self.indicatorView.isHidden = false
        case false:
            self.indicatorView.isHidden = true
            self.indicatorView.stopAnimating()
        }

    }
    
    func createPasswordButtonTapped() {
        passwordToUnlock = generatePassword(digits: 3)
        self.createPasswordButton.setTitle("Generate password"~ + " \(passwordToUnlock)", for: .normal)

        let operation = BrudForceOperation(doBlock: {
            self.brudPass = self.bruteForce(passwordToUnlock: self.passwordToUnlock)

        })
        
        let endHandleOperation = BrudForceOperation(doBlock: {
            self.activityIndicatorHandler(state: false)
            self.unvealdPassword(password: self.brudPass)
            self.createPasswordButton.setTitle("Hack password"~, for: .normal)
        })
        endHandleOperation.addDependency(operation)
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .background
        operationQueue.addOperation(operation)
        OperationQueue.main.addOperation {
            if operation.isExecuting {
                self.activityIndicatorHandler(state: true)
            }
        }
        OperationQueue.main.addOperation(endHandleOperation)
    }
    
    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                       frame: CGRect? = nil,
                                       center: CGPoint? = nil) -> UIActivityIndicatorView {

        let activityIndicatorView = UIActivityIndicatorView(style: style)

        if let frame = frame {
            activityIndicatorView.frame = frame
        }

        if let center = center {
            activityIndicatorView.center = center
        }

        return activityIndicatorView
    }

    @objc func loginTextChanged(_ textField: UITextField) {
        userName = textField.text
        wrongPswdView.isHidden = true
        inputSourceView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @objc func passwordTextChanged(_ textField: UITextField) {
        userPassword = textField.text
        wrongPswdView.isHidden = true
        inputSourceView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @objc func secureTypeOn(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }

    @objc func passwordFieldTapped(_ textField: UITextField) {
        wrongPswdView.isHidden = true
        inputSourceView.layer.borderColor = UIColor.lightGray.cgColor
    }
//MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        users = realm.objects(Credentials.self)
        setupViews()
        setupConstraits()
        loginTextField.keyboardType = .emailAddress
      //  googleSignInButton.addTarget(self, action: #selector(googleAuthLogin), for: .touchUpInside)
     //   signInLineButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)

       // print("User name is \(myUser.firstName)")
    }
    



    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
//MARK: Setup
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(loginButton)

//        contentView.addSubview(wrongPswdView)
//        contentView.addSubview(createPasswordButton)
//        wrongPswdView.isHidden = true
        
        contentView.addSubview(googleSignInButton)
        contentView.addSubview(inputSourceView)
        inputSourceView.addSubview(loginTextField)
        inputSourceView.addSubview(passwordTextField)
        
//        contentView.addSubview(indicatorView)
        
        indicatorView.isHidden = true
        contentView.addSubview(signInLineButton)
    }
    
    func setupConstraits() {
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(120)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        inputSourceView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(100)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(view.bounds.width - 40)
            make.height.equalTo(100)
        }
        
        loginTextField.snp.makeConstraints { (make) in
            make.top.equalTo(inputSourceView.snp.top)
            make.leading.equalTo(inputSourceView.snp.leading)
            make.trailing.equalTo(inputSourceView.snp.trailing)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(inputSourceView.snp.top).offset(50)
            make.leading.equalTo(inputSourceView.snp.leading)
            make.trailing.equalTo(inputSourceView.snp.trailing)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(450)
            make.height.equalTo(50)
            make.leading.equalTo(inputSourceView.snp.leading)
            make.trailing.equalTo(inputSourceView.snp.trailing)
        }
        
        googleSignInButton.snp.makeConstraints { (make) in
            make.top.equalTo(signInLineButton.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(signInLineButton.snp.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        
//        wrongPswdView.snp.makeConstraints { (make) in
//            make.top.equalTo(loginButton.snp.bottom).offset(5)
//            make.centerX.equalTo(loginButton.snp.centerX)
//        }
    
        
//        indicatorView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(passwordTextField.snp.centerY)
//            make.width.equalTo(20)
//            make.trailing.equalTo(inputSourceView.snp.trailing).offset(-15)
//            make.height.equalTo(20)
//        }
        
        signInLineButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
 
    }
}

private extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            contentView.contentInset.bottom = keyboardSize.height
            contentView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height - 80,
                right: 0
            )
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        contentView.contentInset.bottom = .zero
        contentView.verticalScrollIndicatorInsets = .zero
    }
    
    
}

extension LoginViewController {
    
//MARK: BrudForce Logic
    func bruteForce(passwordToUnlock: String) -> String {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)

        }
        
        return password
    }
    
    func generatePassword(digits: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
        return String((0..<digits).map{ _ in letters.randomElement()! })
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}

//MARK: Login and Sign in logic
extension LoginViewController {
    
    @objc func googleAuthLogin() {
        let googleConfig = GIDConfiguration(clientID: "453388259695-17omfcqm8fr926fcehguloregfpm1rni.apps.googleusercontent.com")
        self.googleSignIn.signIn(with: googleConfig, presenting: self) { user, error in
            if error == nil {
                guard let user = user else {
                    print("Uh oh. The user cancelled the Google login.")
                    return
                }
                self.myUser.id = user.userID ?? ""
                self.myUser.idToken = user.authentication.idToken ?? ""
                self.myUser.firstName = user.profile?.givenName ?? ""
                self.myUser.lastName = user.profile?.familyName ?? ""
                self.myUser.email = user.profile?.email ?? ""
                self.myUser.googleProfilePicURL = user.profile?.imageURL(withDimension: 150)?.absoluteString ?? ""
            }
        }
    }
    
    func signInButtonTapped() {
        let controller = SignUpViewController()
        controller.delegate = self.inspector
        self.present(controller, animated: true)
    }
    
    func loginButtonTapped() {
        if self.loginTextField.text != "" && self.passwordTextField.text != "" {
            inspector.checkCredentials(email: self.loginTextField.text!, password: self.passwordTextField.text!, iniciator: self, realm: true)
        } else {
            self.present(loginAlert(), animated: true, completion: nil)
            return
        }
    }
}

