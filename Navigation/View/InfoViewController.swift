import UIKit
import SnapKit
class InfoViewController: UIViewController {
    
    var planet: Planet?
    
    var citizens: [String] = []
    
    var rows = 0
    
    lazy var userTextLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "no data received"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tableView: UITableView = {
        var table = UITableView()
        table.frame = .zero
        return table
    }()
    
    var cell: UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    lazy var planetLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "no data received"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.title = "Info"
        setupViews()
        setupConstraints()
        getUsers(){ data in
            DispatchQueue.main.async {
                self.userTextLabel.text = data!
            }
        }
        receiveData()
    }
    
    func receiveData() {
        let getPlanetOperation = BrudForceOperation(doBlock: {
            getPlanet() { planet in
                self.planet = planet
                for i in 0 ... self.planet!.residents.count - 1 {
                    getCitizen(address: self.planet!.residents[i]) { name in
                        self.citizens.append(name!)
                        DispatchQueue.main.async {
                            self.rows += 1
                            self.tableView.reloadData()
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.planetLabel.text = "Planet \(self.planet!.name) period is \(self.planet!.orbital_period)"
                }
            }
        })

        OperationQueue.main.addOperation(getPlanetOperation)

    }
    
    @objc func tapAlertButton() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Невозможно прочитать файл", preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(_: UIAlertAction!) in print("Ok Action")})
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {(_: UIAlertAction!) in print("Cancel Action")})
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(userTextLabel)
        view.addSubview(planetLabel)
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NameTableViewCell.self, forCellReuseIdentifier: NameTableViewCell.identifier)

    }
    
    func setupConstraints() {
        userTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.width.equalTo(view.snp.width).offset(-50)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(100)
        }
        
        planetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userTextLabel.snp.bottom).offset(15)
            make.width.equalTo(view.snp.width).offset(-50)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(planetLabel.snp.bottom).offset(15)
            make.width.equalTo(view.snp.width).offset(-50)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameTableViewCell.identifier, for: indexPath) as! NameTableViewCell
        cell.textLabel?.text = self.citizens[indexPath.row]
        return cell
    }

}
