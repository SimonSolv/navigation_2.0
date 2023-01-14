import Foundation
import UIKit
//import RealmSwift

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

class BrudForceOperation: Operation {
    let doBlock: () -> Void

    init(doBlock: @escaping () -> Void) {
        self.doBlock = doBlock

        super.init()
    }
    override func main() {
      //  print("block started")
        doBlock()
      //  print ("block ended")
    }
}

struct UserInfo {
    var firstName: String = ""
    var id: String = ""
    var idToken: String = ""
    var lastName: String = ""
    var email: String = ""
    var googleProfilePicURL: String = ""
}

func loginAlert() -> UIAlertController {
    let alertVC = UIAlertController(title: "Warning:", message: "Fill all neccessary fields", preferredStyle: .alert )
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in print("Ok Action")})
    alertVC.addAction(okAction)
    return alertVC
}

protocol LoginViewControllerDelegate: AnyObject, CheckerServiceProtocol {
    func checkPswd (login: String, password: String) -> Bool
}

//class Credentials: Object  {
//    @Persisted var login: String
//    @Persisted var password: String
//    @Persisted var isLoggedIn: Bool
//    @Persisted(primaryKey: true) var credentialId: ObjectId
//}
