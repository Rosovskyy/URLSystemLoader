//
//  PictureLoaderCell.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PictureLoaderCell: UITableViewCell {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var picture: Picture? {
        didSet {
            guard let picture = self.picture else { return }
            self.setupUI(picture: picture)
        }
    }
    var imageState = ImageState.todo
    
    // MARK: - Rx
    let startLoading = PublishRelay<Void>()
    let pauseLoading = PublishRelay<Void>()
    let resumeLoading = PublishRelay<Void>()
    let deleteImage = PublishRelay<Void>()
    
    // MARK: - IBOutlets
    @IBOutlet private weak var pictureImageView: UIImageView!
    @IBOutlet private weak var imageName: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public
    func configureCell(selectedSection: SelectedSection) {
        
        switch selectedSection {
        case .toDo:
            imageState = .todo
            progressLabel.isHidden = true
            actionButton.setImage(#imageLiteral(resourceName: "startIcon"), for: .normal)
        case .inProgress:
            imageState = .loading
            progressLabel.isHidden = false
            actionButton.setImage(#imageLiteral(resourceName: "pauseIcon"), for: .normal)
        case .done:
            imageState = .downladed
            progressLabel.isHidden = true
            actionButton.setImage(#imageLiteral(resourceName: "deleteIcon"), for: .normal)
        }
        
        if let picture = picture {
            setupUI(picture: picture)
        }
    }
    
    // MARK: - Private
    private func setupUI(picture: Picture) {
        imageName.text = picture.author
        
        if let image = picture.image {
            pictureImageView.image = image
        } else {
            pictureImageView.image = #imageLiteral(resourceName: "noPhotoAvailable")
        }
    }
    
    // MARK: - Actions
    @IBAction func actionButtonTapped(_ sender: Any) {
        switch imageState {
        case .todo:
            startLoading.accept(())
            imageState = .loading
        case .pause:
            resumeLoading.accept(())
            imageState = .loading
            actionButton.setImage(#imageLiteral(resourceName: "startIcon"), for: .normal)
        case .loading:
            pauseLoading.accept(())
            actionButton.setImage(#imageLiteral(resourceName: "pauseIcon"), for: .normal)
            imageState = .pause
        case .downladed:
            deleteImage.accept(())
        }
    }
}
