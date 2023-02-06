import Foundation
import UIKit
import RealmSwift

enum AlertError: String {
    case wrongEmail = "Email is not correct!"
    case shortPassword = "Password should be at least 6 caracters!"
    case wrongPassword = "Password is incorrect"
    case userNotFound = "User not found"
}

class LoginInspector: LoginViewControllerDelegate {
    
    let realm = try! Realm()
    var users: Results<Credentials>?
    var isLoggedIn: Bool = true
    
    
    func checkCredentials(email: String, password: String, iniciator: LoginViewController, realm: Bool) {
        switch realm {
        case true:
            self.isLoggedIn = false
            if isValidEmail(email) != true {
                iniciator.present(CustomWarnAlert(message: AlertError.wrongEmail.rawValue, actionHandler: nil),
                    animated: true)
                return
            } else if password.count < 6 {
                iniciator.present(CustomWarnAlert(message: AlertError.shortPassword.rawValue, actionHandler: nil), animated: true)
                return
            } else {
                users = self.realm.objects(Credentials.self)
                guard let users else {
                    print("Error: Cannot get users")
                    return
                }
                guard users.count > 0 else {
                    iniciator.present(CustomWarnAlert(message: AlertError.userNotFound.rawValue, actionHandler: nil), animated: true)
                    return
                }
                for user in users {
                    if user.login == email && user.password == password {
                        self.isLoggedIn = true
                        try! self.realm.write {
                            user.isLoggedIn = self.isLoggedIn
                        }
                        iniciator.coordinator?.eventAction(event: .loginSuccess, iniciator: iniciator)
                        break
                    }
                    if user.login == email && user.password != password {
                        iniciator.present(CustomWarnAlert(message: AlertError.wrongPassword.rawValue, actionHandler: nil), animated: true)
                        break
                    }
                }
                if self.isLoggedIn == false {
                    iniciator.present(CustomWarnAlert(message: AlertError.userNotFound.rawValue, actionHandler: nil), animated: true)
                }
            }
            
        case false:
            return
//            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//                guard let strongSelf = self else { return }
//                if error != nil {
//                    let alertVC = UIAlertController(title: "Warning:", message: error!.localizedDescription, preferredStyle: .alert )
//                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
//                    })
//                    alertVC.addAction(okAction)
//                    iniciator.present(alertVC, animated: true)
//                    return
//                }
//                if error?.localizedDescription == nil {
//                    iniciator.coordinator?.eventAction(event: .loginSuccess, iniciator: iniciator)
//                }
//            }
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
                iniciator.present(CustomWarnAlert(message: AlertError.wrongEmail.rawValue, actionHandler: nil), animated: true)
                return
            } else if password.count < 6 {
                iniciator.present(CustomWarnAlert(message: AlertError.shortPassword.rawValue, actionHandler: nil), animated: true)
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
            return
//            Auth.auth().createUser(withEmail: login, password: password) { authResult, error in
//                if error != nil {
//                    let alertVC = UIAlertController(title: "Warning:", message: error!.localizedDescription, preferredStyle: .alert )
//                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
//                    })
//                    alertVC.addAction(okAction)
//                    iniciator.present(alertVC, animated: true)
//                    return
//                } else {
//                    print(authResult?.user.refreshToken)
//                    print(authResult?.user.email)
//                }
//                let alertVC = UIAlertController(title: "Success!", message: "You have been signed in", preferredStyle: .alert )
//                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
//                    iniciator.dismiss(animated: true)
//                })
//                alertVC.addAction(okAction)
//                iniciator.present(alertVC, animated: true)
//            }
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
