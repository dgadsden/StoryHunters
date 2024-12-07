import UIKit

protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updateModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "FormTableViewCell"
    private var model: EditProfileFormModel?
    public weak var delegate: FormTableViewCellDelegate?
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: EditProfileFormModel) {
        self.model = model

        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    private func setupConstraints() {
        formLabel.translatesAutoresizingMaskIntoConstraints = false
        field.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Form Label constraints
            formLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            formLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            formLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3),
            formLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            // Field (UITextField) constraints
            field.leadingAnchor.constraint(equalTo: formLabel.trailingAnchor, constant: 5),
            field.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            field.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    // UITextFieldDelegate method to track text changes as the user types
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Update the model with the new text while typing
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        // Notify the delegate immediately while typing
        delegate?.formTableViewCell(self, didUpdateField: model)
        
        return true
    }

    // Keep existing methods for when text editing ends or when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        model?.value = textField.text
        guard let model = model else {
            return
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
    }

}
