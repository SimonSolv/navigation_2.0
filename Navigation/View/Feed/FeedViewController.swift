import UIKit
import SnapKit

class FeedViewController: UIViewController, Coordinated {
    
    var coordinator: CoordinatorProtocol?

    var titleInfo = MyPost(title: "Chuck Norris Joke"~)

    var checkWord: String?

    lazy var firstTextfield: UITextField = {
        let textfield = UITextField()
        textfield.setStyle(style: .other)
        textfield.placeholder = "Enter verification word"~
        textfield.textColor = AppColor.text
        textfield.addTarget(self, action: #selector(firstTextfieldChanged), for: .editingChanged)
        return textfield
    }()

    lazy var redLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: self.view.center.x-75, y: 600, width: 150, height: 50))
        label.layer.backgroundColor = UIColor.systemRed.cgColor
        label.text = "Wrong word"~
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.textColor = .white
        return label
    }()

    lazy var greenLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: self.view.center.x-75, y: 600, width: 150, height: 50))
        label.layer.backgroundColor = UIColor.systemGreen.cgColor
        label.text = "Correct word"~
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.textColor = .white
        return label
    }()

    lazy var checkButton: CustomButton = {
        let btn = CustomButton(title: "Check"~, titleColor: .white, onTap: checkButtonTapped)
        btn.setStyle(style: .login)
        return btn
    }()

    func displayGreenLabel() {
        self.view.addSubview(greenLabel)
    }

    func displayRedLabel() {
        self.view.addSubview(redLabel)
    }

    func displayEptyFieldAlert() {
        let alertVC = UIAlertController(title: "Error"~, message: "Enter something!"~, preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Ok"~, style: .destructive, handler: {(_: UIAlertAction!) in })
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    lazy var postButton1: CustomButton = {
        let btn = CustomButton(title: "Chuck Norris Random Joke"~, titleColor: .white, onTap: openRandomJokes)
        btn.backgroundColor = AppColor.accent
        return btn
    }()

    lazy var postButton2: CustomButton = {
        let btn = CustomButton(title: "Search my joke"~, titleColor: .white, onTap: openSearchJoke)
        btn.backgroundColor = AppColor.accent2
        return btn
    }()

    lazy var buttonsView = UIStackView(arrangedSubviews: [
        self.postButton1,
        self.postButton2
    ])

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.correctNotification(notification:)),
                                               name: Notification.Name("Correct"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.incorrectNotification(notification:)),
                                               name: Notification.Name("Incorrect"),
                                               object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"~
        setupViews()
        setupConstraints()
        buttonsView.distribution = .equalSpacing
        let infoButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(infoTapped))
        navigationItem.rightBarButtonItem = infoButton
    }

    func setupViews() {
        view.backgroundColor = .systemGray4
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.axis = .vertical
        view.addSubview(buttonsView)
        view.addSubview(firstTextfield)
        view.addSubview(checkButton)
    }

    func setupConstraints() {

        buttonsView.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.height.equalTo(210)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        postButton1.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        
        postButton2.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        

        firstTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(buttonsView.snp.bottom).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }

        checkButton.snp.makeConstraints { (make) in
            make.top.equalTo(firstTextfield.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
    }

    @objc func firstTextfieldChanged() {
        checkWord = firstTextfield.text
    }

    @objc func infoTapped() {
        let controller = InfoViewController()
        navigationController?.pushViewController(controller, animated: true)

    }
    
    func openRandomJokes() {
        let controller = JokeViewController()
        navigationController?.pushViewController(controller, animated: true)
        controller.titleName = titleInfo.title
    }
    
    func openSearchJoke() {
        let controller = SearchJokeViewController(style: .grouped)
        navigationController?.pushViewController(controller, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Post" else { return }
        guard segue.destination is JokeViewController else { return }
    }
}
extension FeedViewController {
    public func checkButtonTapped() {
        removeLabels()
        if self.firstTextfield.text == "" {
            displayEptyFieldAlert()
            return
        } else {
            guard self.checkWord != nil
            else {
                displayEptyFieldAlert()
                return
            }
            FeedModel().check(word: self.checkWord!)
        }
    }
    @objc func correctNotification(notification: NSNotification) {
        displayGreenLabel()
    }
    @objc func incorrectNotification(notification: NSNotification) {
        displayRedLabel()
    }
    func removeLabels() {
        redLabel.removeFromSuperview()
        greenLabel.removeFromSuperview()
    }
}
