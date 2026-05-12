import Foundation
import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showMovieDetail(_ show: Show)
    func showCast(_ cast: [Cast])
    func showImages(_ imageUrls: [String])
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
    private let getShowImagesUseCase: GetShowImagesUseCaseProtocol
    
    init(view: MovieDetailViewProtocol, 
         show: Show, 
         getCastUseCase: GetCastUseCaseProtocol = GetCastUseCase(),
         getShowImagesUseCase: GetShowImagesUseCaseProtocol = GetShowImagesUseCase()) {
        self.view = view
        self.show = show
        self.getCastUseCase = getCastUseCase
        self.getShowImagesUseCase = getShowImagesUseCase
    }
    
    func viewDidLoad() {
        view?.showMovieDetail(show)
        loadCast()
        loadImages()
    }
    
    private func loadCast() {
        getCastUseCase.execute(showId: show.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cast):
                    self?.view?.showCast(cast)
                case .failure: break // Errores silenciosos para componentes secundarios
                }
            }
        }
    }
    
    private func loadImages() {
        getShowImagesUseCase.execute(showId: show.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let resources):
                    var urls = resources.compactMap { $0.resolutions.original.url }

                    // Si tenemos un póster original, lo ponemos primero para evitar saltos visuales
                    if let originalPoster = self.show.image?.original {
                        // Eliminamos duplicados si el póster ya está en la galería
                        urls.removeAll { $0 == originalPoster }
                        urls.insert(originalPoster, at: 0)
                    }

                    if !urls.isEmpty {
                        self.view?.showImages(urls)
                    }
                case .failure: break
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
