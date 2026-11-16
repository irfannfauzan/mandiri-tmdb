//
//  MovieDetailViewController.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func showLoading()
    func showDetail(_ detail: MovieDetail, meta: String, genres: String, hasTrailer: Bool)
    func showError(message: String)
}

final class MovieDetailViewController: UIViewController {

    // MARK: - Properties

    private let presenter: MovieDetailPresenterProtocol
    private var imageTasks: [Task<Void, Never>] = []

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let backdropView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.card
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = AppColors.background.cgColor
        imageView.backgroundColor = AppColors.card
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.numberOfLines = 0
        return label
    }()

    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        return label
    }()

    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = AppColors.accent
        label.numberOfLines = 0
        return label
    }()

    private lazy var headerTextStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, metaLabel, genresLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var trailerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Watch trailer"
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 8
        config.baseBackgroundColor = AppColors.accent
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        return UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.presenter.didTapTrailer()
        })
    }()

    private lazy var reviewsButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Reviews"
        config.image = UIImage(systemName: "text.bubble")
        config.imagePadding = 8
        config.baseBackgroundColor = AppColors.accent
        config.baseForegroundColor = AppColors.accent
        config.cornerStyle = .capsule
        return UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.presenter.didTapReviews()
        })
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [trailerButton, reviewsButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 15)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        return label
    }()

    private let overviewTitle: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = AppColors.textPrimary.withAlphaComponent(0.85)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [buttonStack, taglineLabel, overviewTitle, overviewLabel])
        stack.axis = .vertical
        stack.spacing = 14
        stack.setCustomSpacing(8, after: overviewTitle)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.accent
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = AppColors.textSecondary
        return label
    }()

    private lazy var retryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Try again"
        config.baseBackgroundColor = AppColors.accent
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        return UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.presenter.didTapRetry()
        })
    }()

    private lazy var messageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(presenter: MovieDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        imageTasks.forEach { $0.cancel() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = AppColors.background
        setupLayout()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(backdropView)
        scrollView.addSubview(posterView)
        scrollView.addSubview(headerTextStack)
        scrollView.addSubview(bodyStack)
        view.addSubview(loadingIndicator)
        view.addSubview(messageStack)

        let content = scrollView.contentLayoutGuide
        let frame = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backdropView.topAnchor.constraint(equalTo: content.topAnchor),
            backdropView.leadingAnchor.constraint(equalTo: frame.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: frame.trailingAnchor),
            backdropView.heightAnchor.constraint(equalTo: backdropView.widthAnchor, multiplier: 9.0 / 16),

            posterView.leadingAnchor.constraint(equalTo: frame.leadingAnchor, constant: 16),
            posterView.topAnchor.constraint(equalTo: backdropView.bottomAnchor, constant: -50),
            posterView.widthAnchor.constraint(equalToConstant: 100),
            posterView.heightAnchor.constraint(equalToConstant: 150),

            headerTextStack.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 14),
            headerTextStack.trailingAnchor.constraint(equalTo: frame.trailingAnchor, constant: -16),
            headerTextStack.topAnchor.constraint(equalTo: backdropView.bottomAnchor, constant: 12),

            bodyStack.topAnchor.constraint(greaterThanOrEqualTo: posterView.bottomAnchor, constant: 20),
            bodyStack.topAnchor.constraint(greaterThanOrEqualTo: headerTextStack.bottomAnchor, constant: 20),
            bodyStack.leadingAnchor.constraint(equalTo: frame.leadingAnchor, constant: 16),
            bodyStack.trailingAnchor.constraint(equalTo: frame.trailingAnchor, constant: -16),
            bodyStack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -32),

            trailerButton.heightAnchor.constraint(equalToConstant: 44),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    // MARK: - Helpers

    private func loadImage(_ url: URL?, into imageView: UIImageView) {
        guard let url else { return }

        if let cached = ImageLoader.shared.cachedImage(for: url) {
            imageView.image = cached
            return
        }

        let task = Task { [weak imageView] in
            let image = await ImageLoader.shared.load(url)
            guard !Task.isCancelled else { return }
            imageView?.image = image
        }
        imageTasks.append(task)
    }
}

// MARK: - MovieDetailViewProtocol

extension MovieDetailViewController: MovieDetailViewProtocol {

    func showLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        messageStack.isHidden = true
    }

    func showDetail(_ detail: MovieDetail, meta: String, genres: String, hasTrailer: Bool) {
        loadingIndicator.stopAnimating()
        messageStack.isHidden = true
        scrollView.isHidden = false

        title = detail.title
        titleLabel.text = detail.title
        metaLabel.text = meta
        genresLabel.text = genres
        genresLabel.isHidden = genres.isEmpty

        taglineLabel.text = detail.tagline.isEmpty ? nil : "\"\(detail.tagline)\""
        taglineLabel.isHidden = detail.tagline.isEmpty

        overviewLabel.text = detail.overview.isEmpty ? "No overview available." : detail.overview

        trailerButton.isEnabled = hasTrailer
        trailerButton.configuration?.title = hasTrailer ? "Watch trailer" : "No trailer"

        loadImage(detail.backdropURL, into: backdropView)
        loadImage(detail.posterURL, into: posterView)
    }

    func showError(message: String) {
        loadingIndicator.stopAnimating()
        scrollView.isHidden = true
        messageStack.isHidden = false
        messageLabel.text = message
    }
}
