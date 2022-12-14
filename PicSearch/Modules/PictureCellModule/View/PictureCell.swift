//
//  CollectionViewCell.swift
//  JsonParseTest
//
//  Created by Pavel Schulepov on 10.11.2022.
//

import UIKit

final class PictureCell: UICollectionViewCell, PictureCellType {
    
    static let identifire = "idCell"
    var viewModel: PictureCellViewModelType?
    
    //MARK: - UI Elements
    
    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: - Override
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = ColorHelper.lightGray
        addSubviews()
        setupUI()
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ?  0.5 : 1
        }
    }
    
    //MARK: - Add Subviews
    
    private func addSubviews() {
        addSubview(activityIndicator)
        addSubview(imageView)
    }
    
    //MARK: - UI
    
    private func setupUI() {
        imageView.frame = bounds
        activityIndicator.center = imageView.center
        layer.cornerRadius = ConstantHelper.radius
        clipsToBounds = true
    }
    
    //MARK: - Set Data
    
    func setImage() {
        imageView.image = nil
        activityIndicator.startAnimating()
        viewModel?.getDownloadImage(completion: { [weak self] data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
                self?.activityIndicator.stopAnimating()
            }
        })
    }
}
