import UIKit
import FirebaseAuth
import FirebaseCore
//import RealmSwift

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
        var isAuth = true
//        let realm = try! Realm()
//        let users = realm.objects(Credentials.self)
//        isAuth = users.contains { $0.isLoggedIn }
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



