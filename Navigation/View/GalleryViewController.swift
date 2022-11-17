import UIKit
import SnapKit

class GalleryViewController: UIViewController, Coordinated {
    
    var coordinator: CoordinatorProtocol?
    
    var storage = PhotoStorage()
    
    var deletingImage: ImageSet?
    
    var timerActive: Bool = true
    
    lazy var undoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    func unDo() {
        timerActive = false
        guard let insImage = deletingImage else {return}
        self.storage.photoGrid.insert(insImage, at: insImage.rowIndex)
        self.collectionView.reloadData()
    }
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var undoButton: CustomButton = {
        let label = CustomButton(title: "Undo deleting", titleColor: .systemGray, onTap: {
            self.unDo()
        })
        label.titleLabel!.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var undoTime: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    var largePhotoIndexPath: IndexPath? {
        didSet {
            var indexPaths: [IndexPath] = []
            if let largePhotoIndexPath = largePhotoIndexPath {
                indexPaths.append(largePhotoIndexPath)
            }
            
            if let oldValue = oldValue {
                indexPaths.append(oldValue)
            }
            
            collectionView.performBatchUpdates({
                
                self.collectionView.reloadItems(at: indexPaths)
            },completion: { _ in
                if let largePhotoIndexPath = self.largePhotoIndexPath {
                        self.collectionView.scrollToItem(
                        at: largePhotoIndexPath,
                        at: .centeredVertically,
                        animated: true)
                }
            })
        }
    }
    
    func deleteCell(_ image: UIImage) {
        guard storage.photoGrid.count >= 0 else { return }
        self.undoTime.text = ""
        self.timerActive = true
        createTimer()
        if storage.photoGrid.count == 1 {
            storage.photoGrid = []
        } else if storage.photoGrid.count > 1 {
            for i in 0...storage.photoGrid.count - 2 {
                if storage.photoGrid[i].image == image {
                    storage.photoGrid.remove(at: i)
                    let del = ImageSet(rowIndex: i, image: image)
                    self.deletingImage = del
                }
            }
        }
        self.collectionView.reloadData()
    }
//MARK: Timer
    
    func createTimer() {
        var time = 6
        self.undoView.isHidden = false
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            if time == 1 || self!.timerActive == false {
                timer.invalidate()
                self?.undoView.isHidden = true
            }
            DispatchQueue.main.async {
                time -= 1
                if time != 0 {
                    self?.undoTime.text = "\(time)"
                }
            }
            })
    }
    

//MARK: Constraints
    private func setupViews() {

        view.addSubview(collectionView)
        view.addSubview(undoView)
        undoView.addSubview(undoButton)
        undoView.addSubview(undoTime)
        undoView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        undoView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
        
        undoButton.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.centerY.equalTo(undoView.snp.centerY)
            make.leading.equalTo(undoView.snp.leading).offset(5)
            make.height.equalTo(40)
        }
        
        undoTime.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.centerY.equalTo(undoView.snp.centerY)
            make.trailing.equalTo(undoView.snp.trailing).offset(-25)
            make.height.equalTo(40)
        }


    }
//MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photo gallery"
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Photo gallery"
    }

}

//MARK: CollectionView settings and layout
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storage.photoGrid.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier,
                                                            for: indexPath) as? GalleryCollectionViewCell
        else {
            preconditionFailure("Invalid cell type")
        }
        cell.sourse = storage.photoGrid[indexPath.row]
        cell.controller = self

        guard indexPath == largePhotoIndexPath else {
            cell.trashView.isHidden = true
            return cell
        }
        cell.trashView.isHidden = false
        cell.trashView.isUserInteractionEnabled = true
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == largePhotoIndexPath {
          var size = collectionView.bounds.size
          size.height -= (self.sectionInsets.top +
                          self.sectionInsets.right)
          size.width -= (self.sectionInsets.left +
                         self.sectionInsets.right)
          return size
        }
        
        return CGSize(width:(view.bounds.width - 8 * 4)/3, height: (view.bounds.width - 8 * 4)/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(8.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

      if largePhotoIndexPath == indexPath {
        largePhotoIndexPath = nil
      } else {
        largePhotoIndexPath = indexPath
      }

      return false
    }
    
}
