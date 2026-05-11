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
        title = "Detalle"
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
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showMovieDetail(_ show: Show) {
        titleLabel.text = show.name
        ratingLabel.text = "⭐ \(show.rating?.average ?? 0.0)"
        
        // Renderizado de HTML (Requerimiento del reto)
        if let htmlData = show.summary?.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            if let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) {
                summaryTextView.attributedText = attributedString
            }
        }
        
        // Para el carrusel usaremos la imagen original si existe
        if let originalImage = show.image?.original {
            self.images = [originalImage] // En un caso real buscaríamos más imágenes
            carouselCollectionView.reloadData()
        }
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
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.loadImage(from: images[indexPath.row])
        
        // Limpiar subviews anteriores para no duplicar
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
