import UIKit

class MoviesListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: MoviesListPresenterProtocol?
    private var categories: [ShowCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter = MoviesListPresenter(view: self)
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Categorías"
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Registro de la celda personalizada
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }
}

extension MoviesListViewController: MoviesListViewProtocol {
    func showLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showCategories(_ categories: [ShowCategory]) {
        self.categories = categories
        collectionView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        cell.configure(with: category)
        
        // Manejar la selección de película dentro de la celda
        cell.onMovieSelected = { [weak self] show in
            self?.presenter?.didSelectMovie(show)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 300)
    }
}
