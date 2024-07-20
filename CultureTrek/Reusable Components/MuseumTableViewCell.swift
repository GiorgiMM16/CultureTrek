import UIKit

class MuseumTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    lazy var museumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "FiraCode-Regular", size: 18)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        layoutSubviews()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(hex: "353A40")
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(museumNameLabel)
        NSLayoutConstraint.activate([
            museumNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            museumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            museumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            museumNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
