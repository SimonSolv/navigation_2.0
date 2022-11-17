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

extension CustomButton {
    enum Style {
        case login
        case status
    }
    func setStyle(style: Style) {
        switch style {
        case .login:
            self.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        case .status:
            self.backgroundColor = .blue
            self.layer.cornerRadius = 12
            self.layer.shadowColor = UIColor.black.cgColor
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
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.font = .systemFont(ofSize: 16)
            self.textColor = .black
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always

        case .status:

            self.backgroundColor = .white
            self.layer.cornerRadius = 12
            self.layer.borderWidth = 1
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
            self.layer.borderColor = UIColor.black.cgColor
            self.font = .systemFont(ofSize: 15)
            self.textColor = .black
        case .other:
            self.layer.cornerRadius = 10
            self.backgroundColor = .systemGray6
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.font = .systemFont(ofSize: 16)
            self.textColor = .black
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
        }
    }
}
