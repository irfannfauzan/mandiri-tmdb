//
//  MovieListViewController.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol MovieListViewProtocol: AnyObject {
    func showLoading()
    func showMovies()
    func showEmpty(message: String)
    func showError(message: String)
    func showLoadingMore(_ isLoading: Bool)
    func showLoadMoreError(message: String)
}

final class MovieListViewController: UIViewController {

    // MARK: - Properties

    private let presenter: MovieListPresenterProtocol

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
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

    private let loadMoreIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
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

    init(presenter: MovieListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = AppColors.background
        setupLayout()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func makeLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3), heightDimension: .estimated(220))
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(220)),
            subitems: [item, item, item]
        )
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 60, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(loadMoreIndicator)
        view.addSubview(messageStack)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            loadMoreIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadMoreIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            messageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}

// MARK: - MovieListViewProtocol

extension MovieListViewController: MovieListViewProtocol {

    func showLoading() {
        loadingIndicator.startAnimating()
        collectionView.isHidden = true
        messageStack.isHidden = true
    }

    func showMovies() {
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

    func showLoadingMore(_ isLoading: Bool) {
        isLoading ? loadMoreIndicator.startAnimating() : loadMoreIndicator.stopAnimating()
    }

    func showLoadMoreError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfMovies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier, for: indexPath
        ) as? MovieCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: presenter.movie(at: indexPath.item))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MovieListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplayItem(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMovie(at: indexPath.item)
    }
}
