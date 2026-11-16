//
//  MovieCell.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

final class MovieCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = "MovieCell"

    private var loadTask: Task<Void, Never>?
    private var currentURL: URL?

    // MARK: - UI

    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = AppColors.card
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(metaLabel)

        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 1.5),

            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            metaLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            metaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            metaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        loadTask?.cancel()
        loadTask = nil
        currentURL = nil
        posterView.image = nil
    }

    // MARK: - Configure

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        let year = movie.releaseYear.isEmpty ? "-" : movie.releaseYear
        metaLabel.text = "\(year) · ★ \(String(format: "%.1f", movie.rating))"

        currentURL = movie.posterURL
        guard let url = movie.posterURL else { return }

        if let cached = ImageLoader.shared.cachedImage(for: url) {
            posterView.image = cached
            return
        }

        loadTask = Task { [weak self] in
            let image = await ImageLoader.shared.load(url)
            guard !Task.isCancelled, self?.currentURL == url else { return }
            self?.posterView.image = image
        }
    }
}
