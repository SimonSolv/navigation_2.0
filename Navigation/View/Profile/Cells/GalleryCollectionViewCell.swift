import UIKit
import SnapKit

class GalleryCollectionViewCell: UICollectionViewCell {
    var controller: GalleryViewController?
    static let identifier = "GalleryCollectionViewCell"
    
    var sourse: ImageSet? {
        didSet {
            imageView.image = sourse?.image
        }
    }

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var trashView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "trash.fill")
        image.tintColor = .white
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var trashButton = CustomButton(title: "", titleColor: .white, onTap: {
        self.deletePhoto()
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(trashView)
        trashView.addSubview(trashButton)
        trashView.isHidden = true
        trashView.isUserInteractionEnabled = false

        imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top)
            make.trailing.equalTo(contentView.snp.trailing)
            make.leading.equalTo(contentView.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        trashView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        trashButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    func displayDeletingAlert() {
        let alertVC = UIAlertController(title: "Warning"~, message: "Are you sure you want to delete this photo?"~, preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Delete"~, style: .destructive, handler: {(_: UIAlertAction!) in
            self.controller!.deleteCell(self.imageView.image!)
        })
        let denyAction = UIAlertAction(title: "Cancel"~, style: .default, handler: {(_: UIAlertAction!) in })
        alertVC.addAction(okAction)
        alertVC.addAction(denyAction)
        controller!.present(alertVC, animated: true, completion: nil)
    }
    
    func deletePhoto() {
        displayDeletingAlert()
    }
}
