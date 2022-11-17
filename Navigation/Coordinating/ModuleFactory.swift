import Foundation
import UIKit

final class ModuleFactory: FabricProtocol {
    func makeModule(type: ModuleType) -> UIViewController {
        switch type {
        case .feed:
            let controller: FeedViewController = {
                let controller = FeedViewController()
                controller.tabBarItem = UITabBarItem(title: "Feed", image: .init(imageLiteralResourceName: "connect") , tag: 1)
                controller.coordinator = self.coordinator
                return controller
            }()
            return controller
        case .profile:
            let controller = ProfileViewController()
            controller.tabBarItem = UITabBarItem(title: "Profile", image: .init(imageLiteralResourceName: "profile") , tag: 0)
            controller.coordinator = self.coordinator
            return controller
        case.login:
            let loginController: LoginViewController = {
                let controller = LoginViewController()
                controller.tabBarItem = UITabBarItem(title: "Profile", image: .init(imageLiteralResourceName: "profile") , tag: 0)
                controller.coordinator = self.coordinator
                let myFabric = MyLoginFactory()
                return controller
            }()
            return loginController
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
    
}
