import UIKit

class ProfileViewController: UIViewController, PhotosTableViewCellDelegate, Coordinated {
    
    var coordinator: CoordinatorProtocol?

    let tableView: UITableView = {
        var table = UITableView()
        table.frame = .zero
        return table
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupTableView()
        setupConstraints()
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
        print("GalleryButton Pressed")
    }

    func openGallery() {
        let controller = GalleryViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    func viewallButtonTapped() {
        print("Tapped Arrw")
        openGallery()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Post" else { return }
        guard segue.destination is JokeViewController else { return }
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
        cell?.post = PostStorage.tableModel[indexPath.section].body[indexPath.row - 1]
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return PostStorage.tableModel[section].footer
    }
    
}
