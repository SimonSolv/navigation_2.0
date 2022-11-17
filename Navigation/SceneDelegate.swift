import UIKit
import FirebaseAuth
import FirebaseCore
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate  {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        let appConfiguration = AppConfiguration.allCases.randomElement()!.rawValue
        NetworkService.request(for: appConfiguration)
        FirebaseApp.configure()
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        let initialController = UITabBarController()
        let coordinator = AppCoordinator(controller: initialController)
        let factory = ModuleFactory()
        coordinator.factory = factory
        factory.coordinator = coordinator
        var isAuth = false
        let realm = try! Realm()
        let users = realm.objects(Credentials.self)
        print(users.count)
        if users.count == 1 {
            if users.first?.isLoggedIn == true {
                isAuth = true
            }
        }
        if users.count > 1 {
            for i in 0...users.count - 1 {
                if users[i].isLoggedIn == true {
                    isAuth = true
                }
            }
        }
        window?.rootViewController = coordinator.start(authorised: isAuth)!
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
        do {
            try? FirebaseAuth.Auth.auth().signOut()
            return
            } catch {
            print(error.localizedDescription)
        }
        
    }
}



