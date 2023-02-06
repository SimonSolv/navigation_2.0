import UIKit

class ProfileViewController: UIViewController, PhotosTableViewCellDelegate, Coordinated {
    
    var coordinator: CoordinatorProtocol?
    let coreManager = CoreDataManager.shared
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    let tableView: UITableView = {
        var table = UITableView()
        table.frame = .zero
        return table
    }()

//MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupTableView()
        setupConstraints()
        getData()
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

    }
    func galleryButtonTapped() {
        self.openGallery()
    }

    func openGallery() {
        let controller = GalleryViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

//    private func fetchNews(completion: @escaping (Result<Data, NetworkError>) -> Void) {
//        let endPoint = self.urlComponents()
//        if let url = endPoint.url {
//            self.sendRequest(for: url, completion: completion)
//        } else {
//            completion(.failure(.unknownError))
//        }
//    }
    
    func getData() {
        var news: [Article] = []
        var catchedError: NetworkError?
        let completion: (Result<Data, NetworkError>) -> Void = {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                do {
                    let answer = try self.parse(News.self, from: data)
                    
                    guard answer.articles.count > 0 else {
                        catchedError = .parseError(reason: "Couldn't parse JSON")
                        print(catchedError?.localizedDescription)
                        return
                    }
                    news = answer.articles
                } catch {
                    if let error = error as? NetworkError {
                        catchedError = error
                    } else {
                        catchedError = .unknownError
                    }
                }
            case .failure(let error):
                catchedError = error
            }
            
        }
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=ru&apiKey=4d3913c1ba72456ba01a30bd96e6c741")
        self.networkManager.request(url: url!, completion: completion)
        print(news.count)
    }
    
    private func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
        urlComponents.queryItems = [
            URLQueryItem(name: "country", value: "ru"),
      //      URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "apiKey", value: "d3913c1ba72456ba01a30bd96e6c741"),
        ]
        return urlComponents
    }
    
    private func parse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            let model = try self.decoder.decode(T.self, from: data)
            return model
        } catch let error {
            throw NetworkError.parseError(reason: error.localizedDescription)
        }
    }
    
    func viewallButtonTapped() {
        openGallery()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Post" else { return }
        guard segue.destination is JokeViewController else { return }
    }
    
    
    @objc func handleTap(_ sender: CustomJestureRecognizer) {
        let post = sender.post
        guard post != nil else {
            print ("Unexpected nil Post")
            return
        }
        coreManager.addPost(post: post!)
        print("Saving to Liked")
    }

}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostStorage.tableModel[section].body.count + 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return PostStorage.tableModel.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PostStorage.tableModel[section].sectionHeader
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as! PhotosTableViewCell
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell
        let cellPost = PostStorage.tableModel[indexPath.section].body[indexPath.row - 1]
        let doubleTapp = CustomJestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap(_:)))
        doubleTapp.numberOfTapsRequired = 2
        doubleTapp.post = cellPost
        cell?.addGestureRecognizer(doubleTapp)
        cell?.post = cellPost
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return PostStorage.tableModel[section].footer
    }
    
    
    
}
