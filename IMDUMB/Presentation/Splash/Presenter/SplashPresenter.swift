import Foundation
import FirebaseRemoteConfig

protocol SplashViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
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
        settings.minimumFetchInterval = 0 // Solo para desarrollo
        remoteConfig.configSettings = settings
        
        remoteConfig.fetchAndActivate { [weak self] status, error in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                // Aquí podrías guardar valores en memoria como pide el reto
                let welcomeMessage = self?.remoteConfig["welcome_message"].stringValue ?? ""
                print("Firebase Remote Config: \(welcomeMessage)")
                
                // Pequeño delay para que se vea el splash (opcional)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.view?.navigateToMain()
                }
            }
        }
    }
}
