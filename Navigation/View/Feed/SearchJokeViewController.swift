import UIKit

class SearchJokeViewController: UITableViewController, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        getJokeList(searchString: searchController.searchBar.text!) { jokeArray in
            DispatchQueue.main.async {
                self.jokes = jokeArray ?? []
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    var jokes: [Joke] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: LifeCycle
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        // Custom initialization
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Joke"~
        view.backgroundColor = .systemGray6
        tableView.register(JokeTableViewCell.self, forCellReuseIdentifier: JokeTableViewCell.identifier)

        navigationItem.searchController = searchController
        searchController.isActive = true
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    // MARK: Table view setup
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return jokes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JokeTableViewCell.identifier, for: indexPath)
        
        cell.textLabel?.text = jokes[indexPath.section].text
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let share = UIActivityViewController(activityItems: [jokes[indexPath.section].text], applicationActivities: nil)
        present(share, animated: true)
    }
}
