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
        let tab1 = factory.makeModule(type: .feed) as? FeedViewController
        let tab2 = factory.makeModule(type: .login) as? LoginViewController
        let tab3 = factory.makeModule(type: .profile) as? ProfileViewController
        let navTab3 = UINavigationController(rootViewController: tab3!)
        let navTab1 = UINavigationController(rootViewController: tab1!)
        let navTab2 = UINavigationController(rootViewController: tab2!)
        guard let controller = self.controller else {return}
        controller.tabBar.backgroundColor = .white
        if loginType {
            controller.viewControllers = [navTab1, navTab3]
        } else {
            controller.viewControllers = [navTab1, navTab2]
        }
        self.controller = controller
    }
}
