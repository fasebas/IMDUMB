import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        movieImageView.layer.cornerRadius = 8
        movieImageView.contentMode = .scaleAspectFill
    }
    
    func configure(with show: Show) {
        movieTitleLabel.text = show.name
        movieRatingLabel.text = "⭐ \(show.rating?.average ?? 0.0)"
        
        if let imageUrl = show.image?.medium {
            movieImageView.loadImage(from: imageUrl)
        } else {
            movieImageView.backgroundColor = .systemGray5
        }
    }
}
