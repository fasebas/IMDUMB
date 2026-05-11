import UIKit

class RecommendModalViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    var presenter: RecommendModalPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        // Efecto Blur (Glassmorphism)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        containerView.backgroundColor = AppTheme.Colors.surface.withAlphaComponent(0.9)
        containerView.applyRoundedBorder()
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.textColor = AppTheme.Colors.textPrimary
        titleLabel.font = AppTheme.Fonts.bold(size: 22)
        
        summaryLabel.textColor = AppTheme.Colors.textSecondary
        summaryLabel.font = AppTheme.Fonts.regular(size: 15)
        
        commentTextField.backgroundColor = AppTheme.Colors.background
        commentTextField.textColor = AppTheme.Colors.textPrimary
        commentTextField.layer.cornerRadius = 8
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = AppTheme.Colors.separator.cgColor
        commentTextField.attributedPlaceholder = NSAttributedString(
            string: "Escribe tu recomendación...",
            attributes: [.foregroundColor: AppTheme.Colors.textSecondary]
        )
        
        // Tap para cerrar al tocar fuera
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            presenter?.didTapCancel()
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        presenter?.didTapConfirm(comment: commentTextField.text ?? "")
    }
}

extension RecommendModalViewController: RecommendModalViewProtocol {
    func showMovieDetail(name: String, summary: String) {
        titleLabel.text = name
        
        // Renderizado de HTML con alto contraste dinámico para el modal
        if let htmlData = summary.data(using: .utf8) {
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            let textColor = isDarkMode ? "#E4E4E7" : "#3F3F46"
            let boldColor = isDarkMode ? "#FFFFFF" : "#000000"
            
            let style = """
            <style>
                body { 
                    font-family: -apple-system; 
                    font-size: 15px; 
                    color: \(textColor); 
                    line-height: 1.4; 
                }
                b, strong { 
                    color: \(boldColor); 
                    font-weight: bold;
                }
            </style>
            """
            let htmlString = style + summary
            if let attributedString = try? NSAttributedString(data: htmlString.data(using: .utf8)!, 
                                                            options: [.documentType: NSAttributedString.DocumentType.html], 
                                                            documentAttributes: nil) {
                summaryLabel.attributedText = attributedString
            }
        }
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController(title: "Éxito", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Genial", style: .default, handler: { _ in
            self.dismiss()
        }))
        present(alert, animated: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
}
