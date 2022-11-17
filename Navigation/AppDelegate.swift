import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("User Email: \(user.profile?.email ?? "NO EMAIL")")
    }

    func application(_ application: UIApplication, open url: URL ,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }

}

struct Post {
    var title: String?
}
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        if let error = error {
//            print("Error \(error)")
//            return
//        }
//
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if let error = error {
//                print("Error \(error)")
//                return
//            }
//        }
//    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, options: [UIApplication.OpenURLOptionsKey : Any] = [:], annotation: Any) -> Bool {
//        var handled: Bool
//
//        handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//        if handled {
//            return true
//        }
//
//        // Handle other custom URL types.
//
//        // If not handled by this app, return false.
//        return false
//    }
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        GIDSignIn.sharedInstance().res
//
//
//            .restorePreviousSignIn { user, error in
//            if error != nil || user == nil {
//                // Show the app's signed-out state.
//            } else {
//                // Show the app's signed-in state.
//            }
//        }
//        return true
//    }


