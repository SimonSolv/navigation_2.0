import Foundation
import UIKit

final class ModuleFactory: FabricProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    func makeModule(type: ModuleType) -> UIViewController {
        switch type {
        case .feed:
            let controller: FeedViewController = {
                let controller = FeedViewController()
                controller.tabBarItem = UITabBarItem(title: "Feed"~, image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))
                controller.coordinator = self.coordinator
                return controller
            }()
            return controller
        case .profile:
            let controller = ProfileViewController()
            controller.tabBarItem = UITabBarItem(title: "Profile"~, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
            controller.coordinator = self.coordinator
            return controller
        case .login:
            let loginController: LoginViewController = {
                let controller = LoginViewController()
                controller.tabBarItem = UITabBarItem(title: "Profile"~, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
                controller.coordinator = self.coordinator
                return controller
            }()
            return loginController
        case .liked:
            let likedController: LikedViewController = {
                let controller = LikedViewController()
                controller.tabBarItem = UITabBarItem(title: "Liked"~, image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
                controller.coordinator = self.coordinator
                return controller
            }()
            return likedController
        }
    }
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
