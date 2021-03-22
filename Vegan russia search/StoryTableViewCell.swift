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
        
        contentView.backgroundColor = .green
        contentView.addSubview(_image)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _image.frame = CGRect(x: contentView.center.x-150, y: contentView.center.y-150, width: 300, height: 300)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func loadImage(_ url: URL) {
        getData(from: url) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { [weak self] in
                    self?._image.image = UIImage(named: "AppStoreIcon")
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?._image.image = UIImage(data: data)
            }
        }
    }
    
    func configure (with hit: Hit) {
        let imageUrl = URL(string: "https://veganrussian.ru\(hit.feature_image)")
        guard let url = imageUrl else {
            return
        }
        loadImage(url)
    }
    
}
