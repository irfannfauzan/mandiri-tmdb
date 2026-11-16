//
//  GenreListViewController.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol GenreListViewProtocol: AnyObject {
    func showLoading()
    func showGenres(_ genres: [Genre])
    func showEmpty(message: String)
    func showError(message: String)
}

final class GenreListViewController: UIViewController {
    
    // MARK: - Properties

    private let presenter: GenreListPresenterProtocol
    private var genres: [Genre] = []

    // MARK: - UI

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick a genre to explore"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
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

    init(presenter: GenreListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Genres"
        view.backgroundColor = AppColors.background
        setupNavigationBar()
        setupLayout()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: AppColors.textPrimary]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppColors.textPrimary]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColors.accent
    }

    private func makeLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            ),
            subitems: [item, item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 24, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupLayout() {
        view.addSubview(subtitleLabel)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(messageStack)

        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}

// MARK: - GenreListViewProtocol

extension GenreListViewController: GenreListViewProtocol {

    func showLoading() {
        loadingIndicator.startAnimating()
        collectionView.isHidden = true
        messageStack.isHidden = true
    }

    func showGenres(_ genres: [Genre]) {
        self.genres = genres
        loadingIndicator.stopAnimating()
        messageStack.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func showEmpty(message: String) {
        loadingIndicator.stopAnimating()
        collectionView.isHidden = true
        messageStack.isHidden = false
        messageLabel.text = message
        retryButton.isHidden = true
    }

    func showError(message: String) {
        loadingIndicator.stopAnimating()
        collectionView.isHidden = true
        messageStack.isHidden = false
        messageLabel.text = message
        retryButton.isHidden = false
    }
}

// MARK: - UICollectionViewDataSource

extension GenreListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCell.identifier, for: indexPath
        ) as? GenreCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: genres[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GenreListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectGenre(at: indexPath.item)
    }
}
