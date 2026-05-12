import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        selectionStyle = .none
        
        movieImageView.layer.cornerRadius = 8
        movieImageView.clipsToBounds = true
        movieImageView.contentMode = .scaleAspectFill
        
        movieTitleLabel.textColor = AppTheme.Colors.textPrimary
        movieTitleLabel.font = AppTheme.Fonts.medium(size: 16)
        
        movieRatingLabel.textColor = AppTheme.Colors.primary
        movieRatingLabel.font = AppTheme.Fonts.bold(size: 14)
    }
    
    func configure(with show: Show) {
        movieTitleLabel.text = show.name
        movieRatingLabel.text = "★ \(show.rating?.average ?? 0.0)"
        
        if let imageUrl = show.image?.medium {
            movieImageView.loadImage(from: imageUrl)
        } else {
            movieImageView.backgroundColor = .systemGray5
        }
    }
}
