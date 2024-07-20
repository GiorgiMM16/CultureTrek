import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    private let backgroundImageView = UIImageView()
    private let cityLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImageView()
        setupLabel()
        setupRoundedCorners()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        contentView.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupLabel() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont(name: "FiraCode-Regular", size: 30)
        cityLabel.textColor = .white
        cityLabel.numberOfLines = 1
        contentView.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func setupRoundedCorners() {
        contentView.layer.cornerRadius = 15.0
        contentView.layer.masksToBounds = true
        backgroundImageView.layer.cornerRadius = 10
        backgroundImageView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }

    func configure(with imageUrl: String?, cityName: String, countryName: String) {
        cityLabel.text = "\(cityName), \(countryName)"
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            backgroundImageView.loadImage(from: url)
        } else {
            backgroundImageView.image = nil
        }
    }
}


