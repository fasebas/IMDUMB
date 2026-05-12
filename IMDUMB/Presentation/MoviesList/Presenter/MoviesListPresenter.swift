import Foundation
import UIKit

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

// SOLID: Interface Segregation Principle (ISP)
// El Presenter se comunica con la Vista a través de un protocolo específico (MoviesListViewProtocol),
// asegurando que solo tenga acceso a los métodos que realmente necesita para actualizar la UI.
class MoviesListPresenter: MoviesListPresenterProtocol {
    
    weak var view: MoviesListViewProtocol?
    private let getMoviesUseCase: GetMoviesUseCaseProtocol
    private var categories: [ShowCategory] = []
    
    init(view: MoviesListViewProtocol, getMoviesUseCase: GetMoviesUseCaseProtocol = GetMoviesUseCase()) {
        self.view = view
        self.getMoviesUseCase = getMoviesUseCase
    }
    
    /// Orquesta la carga de películas categorizadas desde la capa de dominio.
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
        view?.hideLoading() // Por si acaso
        let detailVC = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        let presenter = MovieDetailPresenter(view: detailVC, show: show)
        detailVC.presenter = presenter
        
        if let viewController = view as? UIViewController {
            viewController.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
