import UIKit

extension UIImageView {
    func loadImage(from urlString: String?, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        // Verificamos si la imagen ya está en caché (opcional pero recomendado para el reto)
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data, let cachedImage = UIImage(data: data) {
            self.image = cachedImage
            return
        }
        
        // Carga asíncrona
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, let response = response, let image = UIImage(data: data), error == nil else {
                return
            }
            
            // Guardamos en caché
            let cachedData = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedData, for: request)
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
