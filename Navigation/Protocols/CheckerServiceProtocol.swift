import Foundation
import UIKit

protocol CheckerServiceProtocol {
    func signUp(login: String, password: String, iniciator: UIViewController, realm: Bool)
    func checkCredentials(email: String, password: String) -> LoginResult
}
