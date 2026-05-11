import UIKit

extension UIImageView {
    
    // Usamos un tag único para encontrar el indicador de carga y no duplicarlo
    private var loadingIndicatorTag: Int { return 999123 }
    
    func loadImage(from urlString: String?, placeholder: UIImage? = nil) {
        // 1. Limpiar imagen anterior si no hay caché (evita el parpadeo si ya está cargada)
        let cache = URLCache.shared
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        let request = URLRequest(url: url)
        
        // 2. Si ya está en caché, la ponemos de inmediato y salimos
        if let data = cache.cachedResponse(for: request)?.data, let cachedImage = UIImage(data: data) {
            self.stopLoadingIndicator()
            self.image = cachedImage
            return
        }
        
        // 3. Si no está en caché, mostramos el loading y la imagen placeholder
        self.image = placeholder
        self.startLoadingIndicator()
        
        // 4. Carga asíncrona
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.stopLoadingIndicator()
                
                guard let data = data, let response = response, let image = UIImage(data: data), error == nil else {
                    return
                }
                
                // Guardamos en caché para la próxima vez
                let cachedData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                
                // Transición suave (Fade-in)
                self?.alpha = 0
                self?.image = image
                UIView.animate(withDuration: 0.3) {
                    self?.alpha = 1
                }
            }
        }.resume()
    }
    
    private func startLoadingIndicator() {
        if viewWithTag(loadingIndicatorTag) != nil { return }
        
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.tag = loadingIndicatorTag
        indicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        indicator.startAnimating()
        
        self.addSubview(indicator)
    }
    
    private func stopLoadingIndicator() {
        if let indicator = viewWithTag(loadingIndicatorTag) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}
