import UIKit

enum AppTheme {
    // Colores Adaptables (Soportan modo Light y Dark automáticamente)
    enum Colors {
        static var background: UIColor {
            return .systemBackground
        }
        
        static var surface: UIColor {
            return UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark 
                    ? UIColor(red: 0.09, green: 0.09, blue: 0.11, alpha: 1.0) // Zinc-900
                    : UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0) // Zinc-50
            }
        }
        
        static var primary: UIColor {
            return .systemBlue
        }
        
        static var textPrimary: UIColor {
            return .label
        }
        
        static var textSecondary: UIColor {
            return .secondaryLabel
        }
        
        static var separator: UIColor {
            return .separator
        }
    }
    
    enum Fonts {
        static func bold(size: CGFloat) -> UIFont {
            return .systemFont(ofSize: size, weight: .bold)
        }
        static func medium(size: CGFloat) -> UIFont {
            return .systemFont(ofSize: size, weight: .medium)
        }
        static func regular(size: CGFloat) -> UIFont {
            return .systemFont(ofSize: size, weight: .regular)
        }
    }
}

extension UIView {
    func applyShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 0.15
    }
    
    func applyRoundedBorder() {
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = AppTheme.Colors.separator.cgColor
        self.clipsToBounds = true
    }
}
