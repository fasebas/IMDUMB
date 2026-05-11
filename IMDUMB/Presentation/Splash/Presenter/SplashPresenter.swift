import Foundation
import FirebaseRemoteConfig

protocol SplashViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showInitialText(_ text: String)
    func navigateToMain()
}

protocol SplashPresenterProtocol {
    func viewDidLoad()
}

class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init(view: SplashViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        fetchRemoteConfig()
    }
    
    private func fetchRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetchAndActivate { [weak self] status, error in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                let welcomeMessage = self?.remoteConfig["welcome_message"].stringValue ?? "IMDUMB"
                self?.view?.showInitialText(welcomeMessage)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.view?.navigateToMain()
                }
            }
        }
    }
}
