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
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
        
        // Limpiar HTML para el modal simple
        if let htmlData = summary.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            if let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) {
                summaryLabel.text = attributedString.string
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
