import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var movies: [Show] = []
    var onMovieSelected: ((Show) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        contentView.backgroundColor = AppTheme.Colors.surface
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = AppTheme.Colors.separator.cgColor
        contentView.clipsToBounds = true
        
        // Sutil sombra para dar profundidad
        self.applyShadow()
        
        categoryTitleLabel.textColor = AppTheme.Colors.textPrimary
        categoryTitleLabel.font = AppTheme.Fonts.bold(size: 22)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        tableView.separatorStyle = .none
    }
    
    func configure(with category: ShowCategory) {
        categoryTitleLabel.text = category.title
        self.movies = category.shows
        tableView.reloadData()
    }
}

extension CategoryCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onMovieSelected?(movies[indexPath.row])
    }
}
