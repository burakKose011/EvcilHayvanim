import UIKit

class SplashViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTimer()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Pet resmini ayarla
        if let petImage = UIImage(named: "pett") {
            imageView.image = petImage
        }
        
        view.addSubview(imageView)
        
        // Resmi tüm ekranı kaplayacak şekilde yerleştir
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTimer() {
        // 3 saniye sonra ana sayfaya geç
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToMainScreen()
        }
    }
    
    private func navigateToMainScreen() {
        let mainTabBarController = MainTabBarController()
        
        // Geçiş animasyonu ile ana sayfaya geç - iOS 15+ uyumlu
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window,
                             duration: 0.5,
                             options: .transitionCrossDissolve,
                             animations: {
                window.rootViewController = mainTabBarController
            }, completion: nil)
        }
    }
} 
