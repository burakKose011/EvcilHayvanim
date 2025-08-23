import UIKit

public class SplashViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTimer()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBlue // Test için mavi arka plan
        
        // Test label ekle
        let testLabel = UILabel()
        testLabel.text = "EvcilHayvanim Uygulaması"
        testLabel.textColor = .white
        testLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        testLabel.textAlignment = .center
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(testLabel)
        
        // Label'ı ortala
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Pet resmini ayarla (eğer varsa)
        if let petImage = UIImage(named: "pett") {
            imageView.image = petImage
            view.addSubview(imageView)
            
            // Resmi tüm ekranı kaplayacak şekilde yerleştir
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    private func setupTimer() {
        // 3 saniye sonra ana sayfaya geç
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToMainScreen()
        }
    }
    
    private func navigateToMainScreen() {
        // Create main tab bar controller through class name
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
