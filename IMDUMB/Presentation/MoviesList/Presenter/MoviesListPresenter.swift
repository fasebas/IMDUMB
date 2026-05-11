import Foundation

protocol MoviesListViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showCategories(_ categories: [ShowCategory])
    func showError(_ message: String)
}

protocol MoviesListPresenterProtocol {
    func viewDidLoad()
    func didSelectMovie(_ show: Show)
}

class MoviesListPresenter: MoviesListPresenterProtocol {
    weak var view: MoviesListViewProtocol?
    private let getMoviesUseCase: GetMoviesUseCaseProtocol
    private var categories: [ShowCategory] = []
    
    init(view: MoviesListViewProtocol, getMoviesUseCase: GetMoviesUseCaseProtocol = GetMoviesUseCase()) {
        self.view = view
        self.getMoviesUseCase = getMoviesUseCase
    }
    
    func viewDidLoad() {
        view?.showLoading()
        getMoviesUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.view?.showCategories(categories)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didSelectMovie(_ show: Show) {
        // Lógica para navegar al detalle
        print("Seleccionada película: \(show.name)")
    }
}
