import UIKit
import SnapKit

class LikedViewController: UIViewController, Coordinated, UITableViewDelegate, UITableViewDataSource {

    var coordinator: CoordinatorProtocol?

    let coreManager = CoreDataManager.shared
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreManager.getPosts()
        title = "Liked posts"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    //MARK: TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = coreManager.likedPosts[indexPath.row]
        let cellPost = PostBody(title: post.title!,
                                imageName: post.image!,
                                bodyText: post.text!,
                                likes: post.likes,
                                views: post.views)
        cell.post = cellPost
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreManager.likedPosts.count
    }

}
