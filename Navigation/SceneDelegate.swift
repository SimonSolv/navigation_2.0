import UIKit
import RealmSwift
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate  {

    var window: UIWindow?
    let notificationService = LocalNotificationService()
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        let appConfiguration = AppConfiguration.allCases.randomElement()!.rawValue
        NetworkService.request(for: appConfiguration)
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
        isAuth = users.contains { $0.isLoggedIn }
        window?.rootViewController = coordinator.start(authorised: isAuth)!
        notificationService.registeForLatestUpdatesIfPossible()
    }
    
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
}



