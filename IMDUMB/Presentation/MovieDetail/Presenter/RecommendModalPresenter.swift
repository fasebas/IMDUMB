import Foundation

protocol RecommendModalViewProtocol: AnyObject {
    func showMovieDetail(name: String, summary: String)
    func showSuccess(message: String)
    func dismiss()
}

protocol RecommendModalPresenterProtocol {
    func viewDidLoad()
    func didTapConfirm(comment: String)
    func didTapCancel()
}

class RecommendModalPresenter: RecommendModalPresenterProtocol {
    weak var view: RecommendModalViewProtocol?
    private let movieName: String
    private let movieSummary: String
    
    init(view: RecommendModalViewProtocol, movieName: String, movieSummary: String) {
        self.view = view
        self.movieName = movieName
        self.movieSummary = movieSummary
    }
    
    func viewDidLoad() {
        view?.showMovieDetail(name: movieName, summary: movieSummary)
    }
    
    func didTapConfirm(comment: String) {
        // Aquí se podría integrar un servicio para guardar el comentario
        print("Comentario para \(movieName): \(comment)")
        view?.showSuccess(message: "¡Gracias por recomendar \(movieName)!")
    }
    
    func didTapCancel() {
        view?.dismiss()
    }
}
