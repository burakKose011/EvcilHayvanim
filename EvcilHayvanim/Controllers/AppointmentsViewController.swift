//
//  AppointmentsViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

public class AppointmentsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header Section
    private let headerView = UIView()
    private let welcomeLabel = UILabel()
    private let todayLabel = UILabel()
    private let statsStackView = UIStackView()
    
    // Stats Cards
    private let todayCard = UIView()
    private var todayCountLabel = UILabel()
    private var todayTitleLabel = UILabel()
    private var todayIconView = UIImageView()
    
    private let upcomingCard = UIView()
    private var upcomingCountLabel = UILabel()
    private var upcomingTitleLabel = UILabel()
    private var upcomingIconView = UIImageView()
    
    private let completedCard = UIView()
    private var completedCountLabel = UILabel()
    private var completedTitleLabel = UILabel()
    private var completedIconView = UIImageView()
    
    // Filter Section
    private let filterCard = UIView()
    private let filterLabel = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["Bugün", "Yaklaşan", "Geçmiş", "Tümü"])
    
    // Appointments Section
    private let appointmentsCard = UIView()
    private let appointmentsTitleLabel = UILabel()
    private let tableView = UITableView()
    private let emptyStateView = UIView()
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    private let emptyStateSubtitle = UILabel()
    
    // Add Button
    private let addButton = UIButton()
    
    // MARK: - Properties
    private var allAppointments: [AppointmentModel] = []
    private var filteredAppointments: [AppointmentModel] = []
    private var currentFilter: AppointmentFilter = .today
    
    enum AppointmentFilter: Int, CaseIterable {
        case today = 0
        case upcoming = 1
        case past = 2
        case all = 3
        
        var title: String {
            switch self {
            case .today: return "Bugün"
            case .upcoming: return "Yaklaşan"
            case .past: return "Geçmiş"
            case .all: return "Tümü"
            }
        }
    }
    
    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadAppointments()
        setupAnimations()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAppointments()
        updateStats()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = "Randevular"
        
        setupNavigationBar()
        setupScrollView()
        setupHeaderSection()
        setupStatsCards()
        setupFilterSection()
        setupAppointmentsSection()
        setupAddButton()
        setupEmptyState()
        
        setupInitialAnimationStates()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(addAppointmentTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = DesignSystem.Colors.primary
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .automatic
    }
    
    private func setupHeaderSection() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeLabel.text = "Randevu Takibi"
        welcomeLabel.font = DesignSystem.Typography.title1
        welcomeLabel.textColor = DesignSystem.Colors.textPrimary
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        todayLabel.text = dateFormatter.string(from: Date())
        todayLabel.font = DesignSystem.Typography.callout
        todayLabel.textColor = DesignSystem.Colors.textSecondary
        
        headerView.addSubview(welcomeLabel)
        headerView.addSubview(todayLabel)
        
        contentView.addSubview(headerView)
    }
    
    private func setupStatsCards() {
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        todayCard.translatesAutoresizingMaskIntoConstraints = false
        upcomingCard.translatesAutoresizingMaskIntoConstraints = false
        completedCard.translatesAutoresizingMaskIntoConstraints = false
        
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = DesignSystem.Spacing.md
        
        // Today Card
        setupStatsCard(todayCard, icon: "calendar.badge.clock", count: "0", title: "Bugün", color: DesignSystem.Colors.primary)
        
        // Upcoming Card
        setupStatsCard(upcomingCard, icon: "calendar.badge.plus", count: "0", title: "Yaklaşan", color: DesignSystem.Colors.secondary)
        
        // Completed Card
        setupStatsCard(completedCard, icon: "calendar.badge.checkmark", count: "0", title: "Tamamlanan", color: DesignSystem.Colors.success)
        
        statsStackView.addArrangedSubview(todayCard)
        statsStackView.addArrangedSubview(upcomingCard)
        statsStackView.addArrangedSubview(completedCard)
        
        contentView.addSubview(statsStackView)
    }
    
    private func setupStatsCard(_ card: UIView, icon: String, count: String, title: String, color: UIColor) {
        let iconView = UIImageView()
        let countLabel = UILabel()
        let titleLabel = UILabel()
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        
        countLabel.text = count
        countLabel.font = DesignSystem.Typography.title2
        countLabel.textColor = DesignSystem.Colors.textPrimary
        countLabel.textAlignment = .center
        
        titleLabel.text = title
        titleLabel.font = DesignSystem.Typography.caption1
        titleLabel.textColor = DesignSystem.Colors.textSecondary
        titleLabel.textAlignment = .center
        
        card.backgroundColor = DesignSystem.Colors.cardBackground
        card.layer.cornerRadius = DesignSystem.CornerRadius.large
        card.layer.shadowColor = DesignSystem.Shadow.medium.color.cgColor
        card.layer.shadowOpacity = DesignSystem.Shadow.medium.opacity
        card.layer.shadowOffset = DesignSystem.Shadow.medium.offset
        card.layer.shadowRadius = DesignSystem.Shadow.medium.radius
        
        card.addSubview(iconView)
        card.addSubview(countLabel)
        card.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: DesignSystem.Spacing.md),
            iconView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            countLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: DesignSystem.Spacing.sm),
            countLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: DesignSystem.Spacing.sm),
            countLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -DesignSystem.Spacing.sm),
            
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: DesignSystem.Spacing.xs),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: DesignSystem.Spacing.sm),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -DesignSystem.Spacing.sm),
            titleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -DesignSystem.Spacing.md)
        ])
        
        // Store references for later use
        if card == todayCard {
            todayCountLabel = countLabel
            todayTitleLabel = titleLabel
            todayIconView = iconView
        } else if card == upcomingCard {
            upcomingCountLabel = countLabel
            upcomingTitleLabel = titleLabel
            upcomingIconView = iconView
        } else if card == completedCard {
            completedCountLabel = countLabel
            completedTitleLabel = titleLabel
            completedIconView = iconView
        }
    }
    
    private func setupFilterSection() {
        filterCard.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        filterCard.backgroundColor = DesignSystem.Colors.cardBackground
        filterCard.layer.cornerRadius = DesignSystem.CornerRadius.large
        filterCard.layer.shadowColor = DesignSystem.Shadow.small.color.cgColor
        filterCard.layer.shadowOpacity = DesignSystem.Shadow.small.opacity
        filterCard.layer.shadowOffset = DesignSystem.Shadow.small.offset
        filterCard.layer.shadowRadius = DesignSystem.Shadow.small.radius
        
        filterLabel.text = "Filtrele"
        filterLabel.font = DesignSystem.Typography.headline
        filterLabel.textColor = DesignSystem.Colors.textPrimary
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = DesignSystem.Colors.primary
        segmentedControl.backgroundColor = DesignSystem.Colors.surfaceBackground
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        filterCard.addSubview(filterLabel)
        filterCard.addSubview(segmentedControl)
        
        contentView.addSubview(filterCard)
    }
    
    private func setupAppointmentsSection() {
        appointmentsCard.translatesAutoresizingMaskIntoConstraints = false
        appointmentsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        appointmentsCard.backgroundColor = DesignSystem.Colors.cardBackground
        appointmentsCard.layer.cornerRadius = DesignSystem.CornerRadius.large
        appointmentsCard.layer.shadowColor = DesignSystem.Shadow.medium.color.cgColor
        appointmentsCard.layer.shadowOpacity = DesignSystem.Shadow.medium.opacity
        appointmentsCard.layer.shadowOffset = DesignSystem.Shadow.medium.offset
        appointmentsCard.layer.shadowRadius = DesignSystem.Shadow.medium.radius
        
        appointmentsTitleLabel.text = "Randevular"
        appointmentsTitleLabel.font = DesignSystem.Typography.title3
        appointmentsTitleLabel.textColor = DesignSystem.Colors.textPrimary
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentTableViewCell.self, forCellReuseIdentifier: "AppointmentCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        appointmentsCard.addSubview(appointmentsTitleLabel)
        appointmentsCard.addSubview(tableView)
        
        contentView.addSubview(appointmentsCard)
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setTitle("📅 Yeni Randevu Ekle", for: .normal)
        addButton.backgroundColor = DesignSystem.Colors.primary
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addButton.layer.cornerRadius = 16
        addButton.layer.shadowColor = DesignSystem.Colors.primary.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowRadius = 8
        addButton.addTarget(self, action: #selector(addAppointmentTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
    }
    
    private func setupEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.isHidden = true
        
        emptyStateImageView.image = UIImage(systemName: "calendar.badge.exclamationmark")
        emptyStateImageView.tintColor = DesignSystem.Colors.textSecondary
        emptyStateImageView.contentMode = .scaleAspectFit
        
        emptyStateLabel.text = "Henüz randevunuz yok"
        emptyStateLabel.applyTitleStyle()
        emptyStateLabel.textAlignment = .center
        
        emptyStateSubtitle.text = "İlk randevunuzu ekleyerek başlayın"
        emptyStateSubtitle.applySubtitleStyle()
        emptyStateSubtitle.textAlignment = .center
        emptyStateSubtitle.numberOfLines = 0
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubtitle)
        
        appointmentsCard.addSubview(emptyStateView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -DesignSystem.Spacing.md),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header Section
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            welcomeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: DesignSystem.Spacing.md),
            welcomeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: DesignSystem.Spacing.lg),
            welcomeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -DesignSystem.Spacing.lg),
            
            todayLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: DesignSystem.Spacing.xs),
            todayLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: DesignSystem.Spacing.lg),
            todayLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -DesignSystem.Spacing.lg),
            
            // Stats Cards
            statsStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: DesignSystem.Spacing.md),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.lg),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.lg),
            statsStackView.heightAnchor.constraint(equalToConstant: 100),
            
            // Filter Section
            filterCard.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: DesignSystem.Spacing.lg),
            filterCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.lg),
            filterCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.lg),
            filterCard.heightAnchor.constraint(equalToConstant: 100),
            
            filterLabel.topAnchor.constraint(equalTo: filterCard.topAnchor, constant: DesignSystem.Spacing.md),
            filterLabel.leadingAnchor.constraint(equalTo: filterCard.leadingAnchor, constant: DesignSystem.Spacing.md),
            filterLabel.trailingAnchor.constraint(equalTo: filterCard.trailingAnchor, constant: -DesignSystem.Spacing.md),
            
            segmentedControl.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: DesignSystem.Spacing.sm),
            segmentedControl.leadingAnchor.constraint(equalTo: filterCard.leadingAnchor, constant: DesignSystem.Spacing.md),
            segmentedControl.trailingAnchor.constraint(equalTo: filterCard.trailingAnchor, constant: -DesignSystem.Spacing.md),
            segmentedControl.bottomAnchor.constraint(equalTo: filterCard.bottomAnchor, constant: -DesignSystem.Spacing.md),
            
            // Appointments Section
            appointmentsCard.topAnchor.constraint(equalTo: filterCard.bottomAnchor, constant: DesignSystem.Spacing.lg),
            appointmentsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.lg),
            appointmentsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.lg),
            appointmentsCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            appointmentsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DesignSystem.Spacing.lg),
            
            appointmentsTitleLabel.topAnchor.constraint(equalTo: appointmentsCard.topAnchor, constant: DesignSystem.Spacing.lg),
            appointmentsTitleLabel.leadingAnchor.constraint(equalTo: appointmentsCard.leadingAnchor, constant: DesignSystem.Spacing.lg),
            appointmentsTitleLabel.trailingAnchor.constraint(equalTo: appointmentsCard.trailingAnchor, constant: -DesignSystem.Spacing.lg),
            
            tableView.topAnchor.constraint(equalTo: appointmentsTitleLabel.bottomAnchor, constant: DesignSystem.Spacing.md),
            tableView.leadingAnchor.constraint(equalTo: appointmentsCard.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: appointmentsCard.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: appointmentsCard.bottomAnchor),
            
            // Empty State
            emptyStateView.centerXAnchor.constraint(equalTo: appointmentsCard.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: appointmentsCard.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: appointmentsCard.leadingAnchor, constant: DesignSystem.Spacing.xl),
            emptyStateView.trailingAnchor.constraint(equalTo: appointmentsCard.trailingAnchor, constant: -DesignSystem.Spacing.xl),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: DesignSystem.Spacing.md),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            emptyStateSubtitle.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: DesignSystem.Spacing.sm),
            emptyStateSubtitle.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateSubtitle.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateSubtitle.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
            
            // Add Button
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Data Loading
    private func loadAppointments() {
        allAppointments = DataManager.shared.fetchAppointments()
        filterAppointments()
        updateStats()
    }
    
    private func filterAppointments() {
        let now = Date()
        let calendar = Calendar.current
        
        switch currentFilter {
        case .today:
            filteredAppointments = allAppointments.filter { appointment in
                calendar.isDate(appointment.appointmentDate, inSameDayAs: now) && appointment.appointmentDate >= now
            }
            appointmentsTitleLabel.text = "Bugünkü Randevular"
        case .upcoming:
            filteredAppointments = allAppointments.filter { appointment in
                appointment.appointmentDate > now
            }
            appointmentsTitleLabel.text = "Yaklaşan Randevular"
        case .past:
            filteredAppointments = allAppointments.filter { appointment in
                appointment.appointmentDate < now
            }
            appointmentsTitleLabel.text = "Geçmiş Randevular"
        case .all:
            filteredAppointments = allAppointments
            appointmentsTitleLabel.text = "Tüm Randevular"
        }
        
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func updateStats() {
        let now = Date()
        let calendar = Calendar.current
        
        let todayCount = allAppointments.filter { appointment in
            calendar.isDate(appointment.appointmentDate, inSameDayAs: now)
        }.count
        
        let upcomingCount = allAppointments.filter { appointment in
            appointment.appointmentDate > now
        }.count
        
        let completedCount = allAppointments.filter { appointment in
            appointment.appointmentDate < now && appointment.status == .completed
        }.count
        
        todayCountLabel.text = "\(todayCount)"
        upcomingCountLabel.text = "\(upcomingCount)"
        completedCountLabel.text = "\(completedCount)"
    }
    
    private func updateEmptyState() {
        let isEmpty = filteredAppointments.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    // MARK: - Animations
    private func setupInitialAnimationStates() {
        headerView.alpha = 0.0
        headerView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        statsStackView.alpha = 0.0
        statsStackView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        filterCard.alpha = 0.0
        filterCard.transform = CGAffineTransform(translationX: 0, y: 30)
        
        appointmentsCard.alpha = 0.0
        appointmentsCard.transform = CGAffineTransform(translationX: 0, y: 30)
    }
    
    private func setupAnimations() {
        CuteAnimations.slideInFromBottom(for: headerView, delay: 0.1)
        CuteAnimations.slideInFromBottom(for: statsStackView, delay: 0.2)
        CuteAnimations.slideInFromBottom(for: filterCard, delay: 0.3)
        CuteAnimations.slideInFromBottom(for: appointmentsCard, delay: 0.4)
    }
    
    // MARK: - Actions
    @objc private func addAppointmentTapped() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Add cute bounce animation
        CuteAnimations.bounceAnimation(for: addButton)
        
        let appointmentFormVC = AppointmentFormViewController()
        let navController = UINavigationController(rootViewController: appointmentFormVC)
        present(navController, animated: true)
    }
    
    @objc private func segmentChanged() {
        currentFilter = AppointmentFilter(rawValue: segmentedControl.selectedSegmentIndex) ?? .today
        filterAppointments()
        
        // Add haptic feedback
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension AppointmentsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAppointments.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentTableViewCell
        let appointment = filteredAppointments[indexPath.row]
        cell.configure(with: appointment)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Add cute bounce animation
        if let cell = tableView.cellForRow(at: indexPath) {
            CuteAnimations.bounceAnimation(for: cell)
        }
        
        let appointment = filteredAppointments[indexPath.row]
        let appointmentDetailVC = AppointmentDetailViewController()
        appointmentDetailVC.appointment = appointment
        navigationController?.pushViewController(appointmentDetailVC, animated: true)
    }
}

// MARK: - AppointmentTableViewCell
class AppointmentTableViewCell: UITableViewCell {
    
    private let cardView = UIView()
    private let petImageView = UIImageView()
    private let petNameLabel = UILabel()
    private let reasonLabel = UILabel()
    private let veterinarianLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Clean card styling without status indicator
        cardView.backgroundColor = DesignSystem.Colors.cardBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
        
        // Pet image
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 25
        petImageView.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        
        // Labels with better contrast
        petNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        petNameLabel.textColor = DesignSystem.Colors.textPrimary
        
        reasonLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        reasonLabel.textColor = DesignSystem.Colors.textPrimary
        
        veterinarianLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        veterinarianLabel.textColor = DesignSystem.Colors.textSecondary
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        dateLabel.textColor = DesignSystem.Colors.textSecondary
        
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        timeLabel.textColor = DesignSystem.Colors.primary
        timeLabel.textAlignment = .center
        timeLabel.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        timeLabel.layer.cornerRadius = 8
        timeLabel.layer.masksToBounds = true
        
        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = DesignSystem.Colors.textSecondary
        chevronImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(cardView)
        cardView.addSubview(petImageView)
        cardView.addSubview(petNameLabel)
        cardView.addSubview(reasonLabel)
        cardView.addSubview(veterinarianLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(timeLabel)
        cardView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            petImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            petImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            petImageView.widthAnchor.constraint(equalToConstant: 50),
            petImageView.heightAnchor.constraint(equalToConstant: 50),
            
            petNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            petNameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            petNameLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -12),
            
            reasonLabel.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor, constant: 4),
            reasonLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            reasonLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -12),
            
            veterinarianLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 4),
            veterinarianLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            veterinarianLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: veterinarianLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            timeLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            timeLabel.widthAnchor.constraint(equalToConstant: 60),
            timeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with appointment: AppointmentModel) {
        petNameLabel.text = appointment.petName
        reasonLabel.text = appointment.reason
        veterinarianLabel.text = "👨‍⚕️ Dr. \(appointment.veterinarian)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateLabel.text = "📅 \(dateFormatter.string(from: appointment.appointmentDate))"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeLabel.text = timeFormatter.string(from: appointment.appointmentDate)
        
        // Set pet image (placeholder for now)
        petImageView.image = UIImage(systemName: "pawprint.fill")
        petImageView.tintColor = DesignSystem.Colors.primary
    }
} 
