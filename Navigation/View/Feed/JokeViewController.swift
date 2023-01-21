import UIKit
import SnapKit

class JokeViewController: UIViewController {
    
    lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.backgroundColor = AppColor.white
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.shadowOffset = CGSize(width: 5, height: 5)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Tap Get Joke"~
        return label
    }()
    
    lazy var infoButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    
    lazy var refreshButton: UIButton = {
        let button = CustomButton(title: "Get Joke"~, titleColor: AppColor.text, onTap: {
            getRandomJoke(completion: { joke in
                DispatchQueue.main.async {
                    self.infoButton.isEnabled = true
                    if let joke = joke {
                        self.jokeLabel.text = joke.text
                        self.infoButton.isEnabled = true
                    } else {
                        self.jokeLabel.text = "Something went wrong: push Get Joke again"~
                        self.infoButton.isEnabled = false
                    }
                }
            })
        })
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    var titleName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray4
        navigationItem.rightBarButtonItem = infoButton
        infoButton.isEnabled = false
        self.title = titleName
        setupViews()
        setupConstraits()
    }
    @objc func share() {
        let share = UIActivityViewController(activityItems: [jokeLabel.text!], applicationActivities: nil)
        present(share, animated: true)
    }
    
    func setupViews() {
        view.addSubview(jokeLabel)
        view.addSubview(refreshButton)
    }
    
    func setupConstraits() {
        jokeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(300)
        }
        
        refreshButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.width.equalTo(150)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(30)
        }
    }
}
