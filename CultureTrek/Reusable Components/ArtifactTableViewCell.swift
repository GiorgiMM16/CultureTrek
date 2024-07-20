import UIKit

class ArtifactsTableViewCell: UITableViewCell {
    static let identifier = "ArtifactsTableViewCell"

    private let artifactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let artifactTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "FiraCode-Regular", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(artifactImageView)
        contentView.addSubview(artifactTitleLabel)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        layer.cornerRadius = 15.0
        layer.masksToBounds = true

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        artifactImageView.translatesAutoresizingMaskIntoConstraints = false
        artifactTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            artifactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            artifactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            artifactImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artifactImageView.heightAnchor.constraint(equalToConstant: 200),
            
            artifactTitleLabel.topAnchor.constraint(equalTo: artifactImageView.bottomAnchor, constant: 10),
            artifactTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            artifactTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artifactTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with title: String?, imageURLString: String?) {
        artifactTitleLabel.text = title
        
        if let imageURLString = imageURLString, let url = URL(string: imageURLString) {
            artifactImageView.loadImage(from: url)
        }
    }
}
