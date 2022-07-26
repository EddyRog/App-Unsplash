//
// SearchPhotosCell.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import UIKit

class SearchPhotosCell: UITableViewCell {

    @IBOutlet weak var searchPhotoDescription: UILabel!
    @IBOutlet weak var searchPhotoImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
