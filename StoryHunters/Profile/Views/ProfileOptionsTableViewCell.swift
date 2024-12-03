import UIKit

class ProfileOptionsTableViewCell: UITableViewCell {
    
    var labelName: UILabel!
    var arrowImage: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        setupLabelName()
        setupImageArrow()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.font = .systemFont(ofSize: 16, weight: .medium)
        labelName.textColor = .black
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelName)
    }
    
    func setupImageArrow() {
        let image = UIImage(systemName: "chevron.right")
        arrowImage = UIImageView(image: image)
        arrowImage.tintColor = .gray
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(arrowImage)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            labelName.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            labelName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            arrowImage.centerYAnchor.constraint(equalTo: labelName.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: labelName.trailingAnchor, constant: -16),
            arrowImage.heightAnchor.constraint(equalToConstant: 20),
            arrowImage.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
