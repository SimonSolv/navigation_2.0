import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let  identifier = "lib"

    var source: ImageSet? {
        didSet {
            photoImage.image = source?.image
            rowForImage = (source?.rowIndex)!
        }
    }

    var rowForImage: Int = 0

    lazy var photoImage: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        return image
    }()

    private func setupView() {
        backgroundColor = AppColor.white
        contentView.addSubview(photoImage)
        photoImage.snp.makeConstraints {(make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}
