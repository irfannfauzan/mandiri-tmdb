//
//  ReviewCell.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit
import Kingfisher

final class ReviewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "ReviewCell"

    // MARK: - UI

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.card
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = AppColors.background
        imageView.tintColor = AppColors.textSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = AppColors.textPrimary
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = AppColors.textSecondary
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
        label.backgroundColor = AppColors.accent
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = AppColors.textPrimary.withAlphaComponent(0.85)
        label.numberOfLines = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(avatarView)
        cardView.addSubview(nameStack)
        cardView.addSubview(ratingLabel)
        cardView.addSubview(contentLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            avatarView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36),

            nameStack.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            nameStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            nameStack.trailingAnchor.constraint(lessThanOrEqualTo: ratingLabel.leadingAnchor, constant: -8),

            ratingLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),

            contentLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            contentLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            contentLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.kf.cancelDownloadTask()
        avatarView.image = nil
    }

    // MARK: - Configure

    func configure(with review: Review, date: String, isExpanded: Bool) {
        authorLabel.text = review.author
        dateLabel.text = date
        contentLabel.text = review.content
        contentLabel.numberOfLines = isExpanded ? 0 : 6

        if let rating = review.rating {
            ratingLabel.text = "★ \(String(format: "%.0f", rating))"
            ratingLabel.isHidden = false
        } else {
            ratingLabel.isHidden = true
        }

        avatarView.kf.setImage(
            with: review.avatarURL,
            placeholder: UIImage(systemName: "person.crop.circle.fill"),
            options: [.transition(.fade(0.2))]
        )
    }
}
