import Foundation
import UIKit
import FirebaseAuth
import RealmSwift

class LoginInspector: LoginViewControllerDelegate {
    
    let realm = try! Realm()
    var users: Results<Credentials>?
    var isLoggedIn: Bool = true
    
    let wrongEmailAlert: UIAlertController = {
        let alertVC = UIAlertController(title: "Warning:", message: "Email is not correct!", preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
        })
        alertVC.addAction(okAction)
        return alertVC
    }()
    
    let shortPasswordAlert: UIAlertController = {
        let alertVC = UIAlertController(title: "Warning:", message: "Password should be at least 6 caracters!", preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
        })
        alertVC.addAction(okAction)
        return alertVC
    }()
    
    let wrongPasswordAlert: UIAlertController = {
        let alertVC = UIAlertController(title: "Warning:", message: "Password is incorrect", preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
        })
        alertVC.addAction(okAction)
        return alertVC
    }()
    
    let userNotFoundAlert: UIAlertController = {
        let alertVC = UIAlertController(title: "Warning:", message: "User not found", preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
        })
        alertVC.addAction(okAction)
        return alertVC
    }()
    
    func checkCredentials(email: String, password: String, iniciator: LoginViewController, realm: Bool) {
        switch realm {
        case true:
            if isValidEmail(email) != true {
                iniciator.present(wrongEmailAlert, animated: true)
                return
            } else if password.count < 6 {
                iniciator.present(shortPasswordAlert, animated: true)
                return
            } else {
                print("Realm")
                users = self.realm.objects(Credentials.self)
                if users?.count == 0 {
                    iniciator.present(userNotFoundAlert, animated: true)
                } else if users?.count == 1 {
                    if users!.first?.login == email {
                        if users!.first?.password == password {
                            self.isLoggedIn = true
                            if let user = users!.first{
                                try! self.realm.write {
                                    user.isLoggedIn = self.isLoggedIn
                                }
                            }
                            iniciator.coordinator?.eventAction(event: .loginSuccess, iniciator: iniciator)
                            break
                        } else {
                            iniciator.present(wrongPasswordAlert, animated: true)
                            break
                        }
                    }
                } else if users!.count > 1 {
                    for i in 0...users!.count - 1 {
                        if users?[i].login == email {
                            if users?[i].password == password {
                                self.isLoggedIn = true
                                if let user = users?[i] {
                                    try! self.realm.write {
                                        user.isLoggedIn = self.isLoggedIn
                                    }
                                }
                                iniciator.coordinator?.eventAction(event: .loginSuccess, iniciator: iniciator)
                                break
                            } else {
                                iniciator.present(wrongPasswordAlert, animated: true)
                                break
                            }
                        } else {
                            self.isLoggedIn = false
                        }
                    }
                }
                if self.isLoggedIn == false {
                    iniciator.present(userNotFoundAlert, animated: true)
                }
            }
            
        case false:
            return
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error != nil {
                    let alertVC = UIAlertController(title: "Warning:", message: error!.localizedDescription, preferredStyle: .alert )
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                    })
                    alertVC.addAction(okAction)
                    iniciator.present(alertVC, animated: true)
                    return
                }
                if error?.localizedDescription == nil {
                    iniciator.coordinator?.eventAction(event: .loginSuccess, iniciator: iniciator)
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func checkPswd(login: String, password: String) -> Bool {
        if (login + password).hashValue == Checker.shared.check() {
            print("Accepted")
            return true
        } else {
            print("Denied")
            return false
        }
    }
    
    func signUp(login: String, password: String, iniciator: UIViewController, realm: Bool) {
        switch realm {
        case true:
            if isValidEmail(login) != true {
                iniciator.present(wrongEmailAlert, animated: true)
                return
            } else if password.count < 6 {
                iniciator.present(shortPasswordAlert, animated: true)
                return
            } else {
                var userCredentials = Credentials()
                userCredentials.login = login
                userCredentials.password = password
                userCredentials.isLoggedIn = false
                try! self.realm.write({
                    self.realm.add(userCredentials)
                })
                let alertVC = UIAlertController(title: "Congratulations!", message: "You have benn successfully signed in!", preferredStyle: .alert )
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                    iniciator.dismiss(animated: true)
                })
                alertVC.addAction(okAction)
                iniciator.present(alertVC, animated: true)
            }
        case false:
            Auth.auth().createUser(withEmail: login, password: password) { authResult, error in
                if error != nil {
                    let alertVC = UIAlertController(title: "Warning:", message: error!.localizedDescription, preferredStyle: .alert )
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                    })
                    alertVC.addAction(okAction)
                    iniciator.present(alertVC, animated: true)
                    return
                } else {
                    print(authResult?.user.refreshToken)
                    print(authResult?.user.email)
                }
                let alertVC = UIAlertController(title: "Success!", message: "You have been signed in", preferredStyle: .alert )
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                    iniciator.dismiss(animated: true)
                })
                alertVC.addAction(okAction)
                iniciator.present(alertVC, animated: true)
            }
        }
    }
}
protocol LoginFactory {
    func factory() -> LoginInspector
}

class MyLoginFactory: LoginFactory {
    func factory() -> LoginInspector {
        let factory = LoginInspector()
        return factory
    }
}
