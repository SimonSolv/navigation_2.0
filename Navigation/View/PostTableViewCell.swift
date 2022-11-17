import UIKit
import iOSIntPackage
import SnapKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostCellID"
    lazy var sourceImage: UIImage? = nil
    var post: PostBody? {
        didSet {
            sourceImage = post?.image
//            imageColoring()
            postImageView.image = post?.image
            postTitle.text = post?.title
            postDescription.text = post?.description
            postViews.text = "Views: \(post?.views ?? 0)"
            postLikes.text = "Likes: \(post?.likes ?? 0)"
        }
    }

    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()

    lazy var postTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    lazy var postDescription: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    lazy var postViews: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    lazy var postLikes: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

}

extension PostTableViewCell {

    private func imageColoring() {
        ImageProcessor().processImage(sourceImage: sourceImage ?? UIImage(imageLiteralResourceName: "NoImage"), filter: .colorInvert, completion: { []image in
            postImageView.image = image
        })
    }

    private func setupViews() {
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitle)
        contentView.addSubview(postDescription)
        contentView.addSubview(postViews)
        contentView.addSubview(postLikes)

        postTitle.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        postImageView.snp.makeConstraints { (make) in
            make.top.equalTo(postTitle.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.width)
        }

        postDescription.snp.makeConstraints { (make) in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)

        }

        postViews.snp.makeConstraints { (make) in
            make.top.equalTo(postDescription.snp.bottom).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)

        }

        postLikes.snp.makeConstraints { (make) in
            make.top.equalTo(postViews.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
}
