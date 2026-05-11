import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: MovieDetailPresenterProtocol?
    private var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background
        title = "Detalle"
        
        titleLabel.textColor = AppTheme.Colors.textPrimary
        titleLabel.font = AppTheme.Fonts.bold(size: 28)

        ratingLabel.textColor = AppTheme.Colors.primary
        ratingLabel.font = AppTheme.Fonts.medium(size: 18)

        summaryTextView.backgroundColor = .clear
        summaryTextView.textColor = AppTheme.Colors.textSecondary
        summaryTextView.isEditable = false
        summaryTextView.isScrollEnabled = false

        castLabel.textColor = AppTheme.Colors.textSecondary
        castLabel.font = AppTheme.Fonts.regular(size: 14)
        
        setupCarousel()
    }
    
    private func setupCarousel() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        carouselCollectionView.collectionViewLayout = layout
        carouselCollectionView.isPagingEnabled = true
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
    }
    
    @IBAction func recommendButtonTapped(_ sender: Any) {
        presenter?.didTapRecommend()
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func showLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func showMovieDetail(_ show: Show) {
        titleLabel.text = show.name
        ratingLabel.text = "★ \(show.rating?.average ?? 0.0)"
        
        // Renderizado de HTML con alto contraste dinámico
        if let htmlData = show.summary?.data(using: .utf8) {
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            let textColor = isDarkMode ? "#E4E4E7" : "#3F3F46" // Zinc-200 vs Zinc-700
            let boldColor = isDarkMode ? "#FFFFFF" : "#000000" // Blanco puro vs Negro puro
            
            let style = """
            <style>
                body { 
                    font-family: -apple-system; 
                    font-size: 16px; 
                    color: \(textColor); 
                    line-height: 1.6; 
                }
                b, strong { 
                    color: \(boldColor); 
                    font-weight: bold;
                }
            </style>
            """
            let htmlString = style + (show.summary ?? "")
            if let attributedString = try? NSAttributedString(data: htmlString.data(using: .utf8)!, 
                                                            options: [.documentType: NSAttributedString.DocumentType.html], 
                                                            documentAttributes: nil) {
                summaryTextView.attributedText = attributedString
            }
        }
        // Imagen inicial por si falla el carrusel
        if let originalImage = show.image?.original {
            self.images = [originalImage]
            carouselCollectionView.reloadData()
        }
    }
    
    func showImages(_ imageUrls: [String]) {
        self.images = imageUrls
        self.carouselCollectionView.reloadData()
    }
    
    func showCast(_ cast: [Cast]) {
        let names = cast.prefix(5).map { $0.person.name }.joined(separator: ", ")
        castLabel.text = "Actores: \(names)"
    }
    
    func showError(_ message: String) {
        print("Error: \(message)")
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        let imageView: UIImageView
        if let existingImageView = cell.contentView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            imageView = existingImageView
        } else {
            imageView = UIImageView(frame: cell.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(imageView)
        }
        
        let urlString = images[indexPath.row]
        let secureUrlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        imageView.loadImage(from: secureUrlString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
