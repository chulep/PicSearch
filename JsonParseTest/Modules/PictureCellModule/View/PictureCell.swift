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
    
    //MARK: - Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .gray
        setupUI()
        setImage()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        addSubview(imageView)
        imageView.frame = bounds
        layer.cornerRadius = ConstantHelper.radius
        clipsToBounds = true
    }
    
    private func setImage() {
        viewModel?.getDownloadImage(completion: { [weak self] data in
            guard let data = data,
            let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        })
    }
}