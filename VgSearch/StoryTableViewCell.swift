//
//  StoryTableViewCell.swift
//  Vegan russia search
//
//  Created by Владимир Дельгадильо on 25.02.2021.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    static let identifier = "StoryTableViewCell"
    
    private let _image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        return image
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(_image)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _image.frame = CGRect(x: contentView.center.x - contentView.frame.size.width * 0.4, y: contentView.center.y - contentView.frame.size.height * 0.4, width: contentView.frame.size.width * 0.8, height: contentView.frame.size.height * 0.8)
    }
    
    
    func configure (with url: String, imageCache: ImageCache) {
        imageCache.getImage(relativeUrl: url) {[weak self] image in
            self?._image.image = image
        }
    }
    
}
