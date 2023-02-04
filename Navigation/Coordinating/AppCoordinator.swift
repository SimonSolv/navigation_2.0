import Foundation
import UIKit

enum Event {
    case loginSuccess
    case presentSignIn
    case presentShowJoke
    case presentSearchJokes
    case presentGallery
    case presentInfo
}

class AppCoordinator: CoordinatorProtocol {
    
    var controller: UITabBarController?
    var factory: FactoryProtocol?
    let storage = PhotoStorage()
    
    required init(controller: UITabBarController) {
        self.controller = controller
    }

    func eventAction(event: Event, iniciator: UIViewController) {
        switch event {
        case .loginSuccess:
            let profileController = self.factory?.makeModule(type: .profile) as! ProfileViewController
            iniciator.navigationController?.pushViewController(profileController, animated: false)
        case .presentSignIn:
            let signUiController = SignUpViewController()
            let delegate = LoginInspector()
            signUiController.delegate = delegate
            iniciator.present(signUiController, animated: true)
        case .presentGallery:
            let controller = GalleryViewController()
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .presentSearchJokes:
            let controller = SearchJokeViewController(style: .grouped)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .presentShowJoke:
            let controller = JokeViewController()
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .presentInfo:
            let controller = InfoViewController()
            iniciator.navigationController?.pushViewController(controller, animated: true)
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
        if loginType == true {
            controller.viewControllers = [navFeed, navProfile, navLiked]
        } else {
            controller.viewControllers = [navFeed, navLogin, navLiked]
        }
        self.controller = controller
    }
}
