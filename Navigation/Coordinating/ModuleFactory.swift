import Foundation
import UIKit

final class ModuleFactory: FabricProtocol {
    func makeModule(type: ModuleType) -> UIViewController {
        switch type {
        case .feed:
            let controller: FeedViewController = {
                let controller = FeedViewController()
                controller.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper") , tag: 0)
                controller.coordinator = self.coordinator
                return controller
            }()
            return controller
        case .profile:
            let controller = ProfileViewController()
            controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person") , tag: 1)
            controller.coordinator = self.coordinator
            return controller
        case .login:
            let loginController: LoginViewController = {
                let controller = LoginViewController()
                controller.tabBarItem = UITabBarItem(title: "Profile", image: .init(imageLiteralResourceName: "profile") , tag: 2)
                controller.coordinator = self.coordinator
                return controller
            }()
            return loginController
        case .liked:
            let likedController: LikedViewController = {
                let controller = LikedViewController()
                controller.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart") , tag: 3)
                controller.coordinator = self.coordinator
                return controller
            }()
            return likedController
        }
        
        
    }
    
    var coordinator: CoordinatorProtocol?

}

protocol FabricProtocol: AnyObject {
    var coordinator: CoordinatorProtocol? { get set }
    func makeModule(type: ModuleType) -> UIViewController
}

enum ModuleType {
    case feed
    case profile
    case login
    case liked
    
}
