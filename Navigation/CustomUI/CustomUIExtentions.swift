import UIKit

final class CustomButton: UIButton {
    private var onTap: () -> Void

    init(title: String, titleColor: UIColor, onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        nil
    }
    @objc private func buttonTapped() {
        self.onTap()
    }
}

let wrongEmailAlert: UIAlertController = {
    let alertVC = UIAlertController(title: "Warning:"~, message: "Email is not correct!"~, preferredStyle: .alert )
    let okAction = UIAlertAction(title: "Ok"~, style: .default, handler: {(_: UIAlertAction!) in
    })
    alertVC.addAction(okAction)
    return alertVC
}()

final class CustomWarnAlert: UIAlertController {
    
    init(message: String, actionHandler: ((UIAlertAction) -> Void)?) {
       // self.preferredStyle = .alert
        super.init(nibName: nil, bundle: nil)
        self.title = "Warning"~
        self.message = message
        let action = UIAlertAction(title: "Ok"~, style: .default, handler: actionHandler)
        self.addAction(action)
    }
    required init?(coder: NSCoder) {
        nil
    }

}

struct AppColor {
    static var background: UIColor = {
        return UIColor(named: "AppBackground")!
    }()
    static var border: UIColor = {
        return UIColor(named: "AppBorder")!
    }()
    static var accent: UIColor = {
        return UIColor(named: "AppAccent")!
    }()
    static var accent2: UIColor = {
        return UIColor(named: "AppAccent2")!
    }()
    static var button: UIColor = {
        return UIColor(named: "AppButton")!
    }()
    static var white: UIColor = {
        return UIColor(named: "AppCustomWhite")!
    }()
    static var text: UIColor = {
        return UIColor(named: "AppText")!
    }()
    static var darkText: UIColor = {
        return UIColor(named: "AppDarkText")!
    }()
    static var shadow: UIColor = {
        return UIColor(named: "AppShadow")!
    }()
    static var tabBar: UIColor = {
        return UIColor(named: "AppTabBar")!
    }()
}

extension CustomButton {
    enum Style {
        case login
        case status
    }
    func setStyle(style: Style) {
        switch style {
        case .login:
            self.backgroundColor = AppColor.button
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        case .status:
            self.backgroundColor = AppColor.button
            self.layer.cornerRadius = 12
            self.layer.shadowColor = AppColor.shadow.cgColor
            self.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.layer.shadowRadius = 5
            self.layer.shadowOpacity = 1.0
        }
    }
}

extension UITextField {
    enum Style {
        case login
        case status
        case other
    }
    func setStyle(style: Style) {
        switch style {
        case .login:
            self.backgroundColor = .systemGray6
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.systemGray2.cgColor
            self.font = .systemFont(ofSize: 16)
            self.textColor = AppColor.text
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always

        case .status:
            self.backgroundColor = .white
            self.layer.cornerRadius = 12
            self.layer.borderWidth = 1
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
            self.layer.borderColor = AppColor.border.cgColor
            self.font = .systemFont(ofSize: 15)
            self.textColor = AppColor.text
            
        case .other:
            self.layer.cornerRadius = 10
            self.backgroundColor = .systemGray6
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.font = .systemFont(ofSize: 16)
            self.textColor = AppColor.text
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
        }
    }
}

class CustomJestureRecognizer: UITapGestureRecognizer {
    var post: PostBody?
}
