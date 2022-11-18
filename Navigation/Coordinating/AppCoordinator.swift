import Foundation
import UIKit

enum Event {
    case loginSuccess
    case secondButtonTapped
}

class AppCoordinator: CoordinatorProtocol {
    var controller: UITabBarController?
    var factory: ModuleFactory?
    let storage = PhotoStorage()
    
    var coordinators: [CoordinatorProtocol]?

    
    required init(controller: UITabBarController) {
        self.controller = controller
    }

    func eventAction(event: Event, iniciator: UIViewController) {
        switch event {
        case .loginSuccess:
            let profileController = self.factory?.makeModule(type: .profile) as! ProfileViewController
            iniciator.navigationController?.pushViewController(profileController, animated: false)
        case .secondButtonTapped:
            return
        }
    }

    func start(authorised: Bool) -> UITabBarController? {
        self.setTabBarController(loginType: authorised)
        return controller
    }

    func setTabBarController(loginType: Bool) {
        guard let factory = factory else {
            return
        }
        let feed = factory.makeModule(type: .feed) as? FeedViewController
        let login = factory.makeModule(type: .login) as? LoginViewController
        let profile = factory.makeModule(type: .profile) as? ProfileViewController
        let liked = factory.makeModule(type: .liked) as? LikedViewController
        let navProfile = UINavigationController(rootViewController: profile!)
        let navFeed = UINavigationController(rootViewController: feed!)
        let navLogin = UINavigationController(rootViewController: login!)
        let navLiked = UINavigationController(rootViewController: liked!)
        guard let controller = self.controller else {return}
        controller.tabBar.backgroundColor = .white
        if loginType {
            controller.viewControllers = [navFeed, navProfile, navLiked]
        } else {
            controller.viewControllers = [navFeed, navLogin, navLiked]
        }
        self.controller = controller
    }
}
