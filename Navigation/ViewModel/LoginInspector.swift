import Foundation
import UIKit
import RealmSwift

enum LoginResult: String {
    case wrongEmail = "Email is not correct!"
    case shortPassword = "Password should be at least 6 caracters!"
    case wrongPassword = "Password is incorrect"
    case userNotFound = "User not found"
    case realmError = "Something went wrong. Try later"
    case success
}

class LoginInspector: LoginViewControllerDelegate {

    let realm = try! Realm()
    var users: Results<Credentials>?
    var isLoggedIn: Bool = true
    
    
    func checkCredentials(email: String, password: String) -> LoginResult {
            self.isLoggedIn = false
            if isValidEmail(email) != true {
                return LoginResult.wrongEmail
            } else if password.count < 6 {
                return LoginResult.shortPassword
            } else {
                users = self.realm.objects(Credentials.self)
                guard let users else {
                    return LoginResult.realmError
                }
                guard users.count > 0 else {
                    return LoginResult.userNotFound
                }
                for user in users {
                    if user.login == email && user.password == password {
                        self.isLoggedIn = true
                        try! self.realm.write {
                            user.isLoggedIn = self.isLoggedIn
                        }
                        return LoginResult.success
                    }
                    if user.login == email && user.password != password {
                        return LoginResult.wrongPassword
                    }
                }
                if self.isLoggedIn == false {
                    return LoginResult.userNotFound
                } else {
                    return LoginResult.success
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
                iniciator.present(CustomWarnAlert(message: LoginResult.wrongEmail.rawValue, actionHandler: nil), animated: true)
                return
            } else if password.count < 6 {
                iniciator.present(CustomWarnAlert(message: LoginResult.shortPassword.rawValue, actionHandler: nil), animated: true)
                return
            } else {
                let userCredentials = Credentials()
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
