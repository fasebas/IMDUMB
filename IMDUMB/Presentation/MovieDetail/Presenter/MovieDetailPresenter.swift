import Foundation
import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showMovieDetail(_ show: Show)
    func showCast(_ cast: [Cast])
    func showError(_ message: String)
}

protocol MovieDetailPresenterProtocol {
    func viewDidLoad()
    func didTapRecommend()
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    weak var view: MovieDetailViewProtocol?
    private let show: Show
    private let getCastUseCase: GetCastUseCaseProtocol
    
    init(view: MovieDetailViewProtocol, show: Show, getCastUseCase: GetCastUseCaseProtocol = GetCastUseCase()) {
        self.view = view
        self.show = show
        self.getCastUseCase = getCastUseCase
    }
    
    func viewDidLoad() {
        view?.showMovieDetail(show)
        loadCast()
    }
    
    private func loadCast() {
        view?.showLoading()
        getCastUseCase.execute(showId: show.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let cast):
                    self?.view?.showCast(cast)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didTapRecommend() {
        let modalVC = RecommendModalViewController(nibName: "RecommendModalViewController", bundle: nil)
        let modalPresenter = RecommendModalPresenter(view: modalVC, movieName: show.name, movieSummary: show.summary ?? "")
        modalVC.presenter = modalPresenter
        
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        
        if let viewController = view as? UIViewController {
            viewController.present(modalVC, animated: true)
        }
    }
}
