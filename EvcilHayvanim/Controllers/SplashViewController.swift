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
        print("SplashViewController viewDidLoad called")
        
        // STATUS BAR'ı GİZLE VE TAM EKRAN YAP
        setNeedsStatusBarAppearanceUpdate()
        
        // Tam ekran için ek bir şey yapmaya gerek yok; Auto Layout ve root window zaten tam ekran.
        let screenBounds = UIScreen.main.bounds
        print("SplashViewController: UIScreen main bounds: \(screenBounds)")
        
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = .zero
        }
        
        // BASİT VE GÜVENLİ AYARLAR
        view.backgroundColor = .black  // Arka plan rengi
        
        setupUI()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SplashViewController viewWillAppear called")
        setupTimer()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SplashViewController viewDidAppear called")
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("SplashViewController viewDidLayoutSubviews called")
    }
    
    // STATUS BAR'ı GİZLE
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    // STATUS BAR STİLİ
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        print("SplashViewController setupUI called")
        
        // Sadece pett resmini ekle - arka plan yok
        if let petImage = UIImage(named: "pett") {
            imageView.image = petImage
            imageView.contentMode = .scaleAspectFill  // Tüm ekranı kapla
            imageView.clipsToBounds = true  // Güvenli
            view.addSubview(imageView)
            
            // TAM EKRAN - VIEW SINIRLARINI KULLAN
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            print("ImageView constraints set - simple full screen")
        }
        
        // Ana başlık label'ı ekle
        let titleLabel = UILabel()
        titleLabel.text = "pet yanında"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)  // Daha büyük
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.shadowColor = .black
        titleLabel.shadowOffset = CGSize(width: 4, height: 4)  // Daha belirgin gölge
        titleLabel.alpha = 1.0
        
        view.addSubview(titleLabel)
        
        // Başlığı üst kısma yerleştir - VIEW SINIRLARINI KULLAN
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)  // View sınırlarını kullan
        ])
        
        // Alt bilgi label'ı ekle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "EvcilHayvanim Uygulaması"
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)  // Daha büyük
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.shadowColor = .black
        subtitleLabel.shadowOffset = CGSize(width: 3, height: 3)
        subtitleLabel.alpha = 1.0
        
        view.addSubview(subtitleLabel)
        
        // Alt bilgiyi alt kısma yerleştir - VIEW SINIRLARINI KULLAN
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)  // View sınırlarını kullan
        ])
        
        print("SplashViewController setupUI completed")
    }
    
    private func setupTimer() {
        print("SplashViewController setupTimer called")
        // 5 saniye sonra ana sayfaya geç (daha uzun süre göster)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            print("Timer fired, navigating to main screen")
            self.navigateToMainScreen()
        }
    }
    
    private func navigateToMainScreen() {
        print("SplashViewController navigateToMainScreen called")
        // Create main tab bar controller
        let mainTabBarController = MainTabBarController()
        
        // Geçiş animasyonu ile ana sayfaya geç
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            print("Window found, transitioning to main screen")
            UIView.transition(with: window,
                             duration: 0.5,
                             options: .transitionCrossDissolve,
                             animations: {
                window.rootViewController = mainTabBarController
            }, completion: { _ in
                print("Transition completed")
            })
        } else {
            print("Window not found!")
        }
    }
} 
