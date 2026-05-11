//
//  SplashViewController.swift
//  IMDUMB
//
//  Created by Fabrizio Sipan on 10/05/26.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var presenter: SplashPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = ""
        presenter = SplashPresenter(view: self)
        presenter?.viewDidLoad()
    }
}

extension SplashViewController: SplashViewProtocol {
    func showLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showInitialText(_ text: String) {
        welcomeLabel.text = text
    }
    
    func navigateToMain() {
        DispatchQueue.main.async {
            let moviesListVC = MoviesListViewController(nibName: "MoviesListViewController", bundle: nil)
            let navigationController = UINavigationController(rootViewController: moviesListVC)
            
            // Reemplazar la ventana raíz con una transición suave
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = navigationController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}
