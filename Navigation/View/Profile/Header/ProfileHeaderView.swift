import UIKit
import SnapKit
class ProfileHeaderView: UIView {
    
    static let identifier = "ProfileHeader"
    var status: String? = "Waiting for something..."~
    var isSelected: Bool = false
    var avatarImageView: UIImageView = {
        var image: UIImageView = UIImageView()
        image.image = UIImage(named: "ProfilePic")
        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 3
        image.layer.borderColor = CGColor(srgbRed: 100, green: 100, blue: 100, alpha: 100)
        image.isUserInteractionEnabled = true
        return image
    }()
    var fullNameLabel: UILabel = {
        var name: UILabel = UILabel()
        name.text = "Pajama Kid"~
        name.font = .boldSystemFont(ofSize: 18)
        return name
    }()
    var statusLabel: UILabel = {
        var status: UILabel = UILabel()
        status.font = .systemFont(ofSize: 14)
        status.font = .boldSystemFont(ofSize: 18)
        status.textColor = .gray
        return status
    }()

    lazy var closeButton: CustomButton = {
        let btn = CustomButton(title: "", titleColor: .white) {
            self.animate2()
        }
        btn.addSubview(closeImage)
        btn.bringSubviewToFront(self)
        return btn
    }()
    
    lazy var closeImage: UIImageView = {
        var image: UIImageView = UIImageView()
        image.image = UIImage(systemName: "xmark")
        image.isUserInteractionEnabled = true
        image.sizeThatFits(CGSize(width: 20, height: 20))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .white
        return image
    }()

    
    let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0
        return view
    }()
    var statusTextField: UITextField = {
        var textfield: UITextField = UITextField()
        textfield.setStyle(style: .status)
        textfield.placeholder = "Enter status"~
        textfield.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textfield
    }()
    lazy var setStatusButton: CustomButton = {
        var btn = CustomButton(title: "Set status"~, titleColor: .white, onTap: statusButtonTapped)
        btn.setStyle(style: .status)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
//        addGestureRecognizer(tapGesture)
        statusLabel.text = status
        backgroundColor = .systemGray6
        avatarImageView.addGestureRecognizer(tapGesture)
        
        setupViews()
        setupConstraints()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupConstraints() {

        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(36)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(16)
            make.width.equalTo(103)
            make.height.equalTo(103)
        }
        fullNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(36)
            make.height.equalTo(23)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(fullNameLabel)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(-35)
            make.bottom.equalTo(avatarImageView).offset(-10)
        }
        statusTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(fullNameLabel)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        setStatusButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(statusTextField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        closeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        dimView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(2000)

        }
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(setStatusButton.snp.bottom).offset(15)
        }

    }
    private func setupViews() {
        addSubview(setStatusButton)
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(dimView)
        addSubview(closeButton)
        bringSubviewToFront(avatarImageView)
        closeButton.isHidden = true
        dimView.isHidden = true
    }

    func statusButtonTapped() {
        self.statusLabel.text = self.status
        self.statusTextField.text = ""
        self.statusTextField.isEnabled = false
    }

    @objc func tap() {
        animate()
    }
    @objc func statusTextChanged(_ textField: UITextField) {
        status = textField.text
    }

    func animate() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.dimView.isHidden = false
                self.avatarImageView.layer.cornerRadius = 0
                self.dimView.layer.opacity = 0.5
                self.avatarImageView.transform = CGAffineTransform(
                    scaleX: (self.window?.bounds.width)!/self.avatarImageView.bounds.width,
                    y: (self.window?.bounds.width)!/self.avatarImageView.bounds.width)
                self.avatarImageView.center = CGPoint(
                    x: (self.window?.bounds.midX)!,
                    y: (self.window?.bounds.midY)!-(self.window?.safeAreaInsets.bottom)!-(self.window?.safeAreaInsets.top)!)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                    self.closeButton.isHidden = false
            }
        })
    }
    func animate2() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.dimView.layer.opacity = 0
                self.sendSubviewToBack(self.dimView)
                self.avatarImageView.layer.cornerRadius = 50
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.avatarImageView.center = CGPoint(x: 66, y: 86)
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.closeButton.isHidden = true
            }
        }, completion: {_ in self.dimView.isHidden = true})
    }
}

