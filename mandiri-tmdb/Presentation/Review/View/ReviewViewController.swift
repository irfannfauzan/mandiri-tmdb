//
//  ReviewsViewController.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol ReviewsViewProtocol: AnyObject {
    func showLoading()
    func showReviews()
    func showEmpty(message: String)
    func showError(message: String)
    func showLoadingMore(_ isLoading: Bool)
    func showLoadMoreError(message: String)
}

final class ReviewsViewController: UIViewController {

    // MARK: - Properties

    private let presenter: ReviewsPresenterProtocol
    private var expandedIds: Set<String> = []

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        table.tableFooterView = footerSpinner
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let footerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = AppColors.accent
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: 0, height: 56)
        return spinner
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

    init(presenter: ReviewsPresenterProtocol) {
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

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(messageStack)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}

// MARK: - ReviewsViewProtocol

extension ReviewsViewController: ReviewsViewProtocol {

    func showLoading() {
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        messageStack.isHidden = true
    }

    func showReviews() {
        loadingIndicator.stopAnimating()
        messageStack.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }

    func showEmpty(message: String) {
        loadingIndicator.stopAnimating()
        tableView.isHidden = true
        messageStack.isHidden = false
        messageLabel.text = message
        retryButton.isHidden = true
    }

    func showError(message: String) {
        loadingIndicator.stopAnimating()
        tableView.isHidden = true
        messageStack.isHidden = false
        messageLabel.text = message
        retryButton.isHidden = false
    }

    func showLoadingMore(_ isLoading: Bool) {
        isLoading ? footerSpinner.startAnimating() : footerSpinner.stopAnimating()
    }

    func showLoadMoreError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ReviewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfReviews
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReviewCell.identifier, for: indexPath
        ) as? ReviewCell else {
            return UITableViewCell()
        }
        let review = presenter.review(at: indexPath.row)
        cell.configure(
            with: review,
            date: presenter.formattedDate(for: review),
            isExpanded: expandedIds.contains(review.id)
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ReviewsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayRow(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = presenter.review(at: indexPath.row).id
        if expandedIds.contains(id) {
            expandedIds.remove(id)
        } else {
            expandedIds.insert(id)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
