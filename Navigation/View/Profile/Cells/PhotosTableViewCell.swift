import UIKit
import iOSIntPackage
import SnapKit

class PhotosTableViewCell: UITableViewCell {
    static let  identifier = "photos"
    weak var delegate: PhotosTableViewCellDelegate?
    var onTap: (() -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = AppColor.background
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier )
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private var tempStorage: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    lazy var viewAllButton: CustomButton = {
        let btn = CustomButton(title: "", titleColor: .white, onTap: viewAllButtonTapped)
        btn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        return btn
    }()

    let photosLabel: UILabel = {
       let label = UILabel()
        label.text = "Photos"~
        label.textColor = UIColor(named: "Text")
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    func viewAllButtonTapped() {
        delegate?.openGallery()
    }
    
    private func setupViews() {
        backgroundColor = AppColor.background
        contentView.backgroundColor = AppColor.background
        contentView.addSubview(photosLabel)
        contentView.addSubview(viewAllButton)
        contentView.addSubview(collectionView)
    }

    private func setupConstraints() {
//        contentView.snp.makeConstraints { (make) in
//            make.height.equalTo(200)
//        }
        
        photosLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.height.equalTo(20)
        }
        
        viewAllButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(photosLabel.snp.centerY)
            make.height.equalTo(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
            make.width.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(photosLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(60)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PhotosTableViewCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoStorage().photoGrid.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.source = PhotoStorage().photoGrid[indexPath.row]
        return cell
    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (contentView.bounds.width - 8*5)/4, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.openGallery()
    }
}
protocol PhotosTableViewCellDelegate: AnyObject {
    func openGallery()
}
