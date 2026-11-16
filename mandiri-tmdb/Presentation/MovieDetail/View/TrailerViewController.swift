//
//  TrailerViewController.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit
import WebKit

final class TrailerViewController: UIViewController {

    // MARK: - Properties

    private let trailer: Trailer

    // MARK: - UI

    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.accent
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Init

    init(trailer: Trailer) {
        self.trailer = trailer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = trailer.name
        view.backgroundColor = .black
        setupNavigationItems()
        setupLayout()
        loadTrailer()
    }

    // MARK: - Setup

    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction { [weak self] _ in self?.dismiss(animated: true) }
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.right.square"),
            primaryAction: UIAction { [weak self] _ in self?.openInYouTube() }
        )
    }

    private func setupLayout() {
        view.addSubview(webView)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 9.0 / 16),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions

    private func loadTrailer() {
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>body{margin:0;background:#000}iframe{width:100%;height:100%;border:0}</style>
        </head>
        <body>
        <iframe src="https://www.youtube.com/embed/\(trailer.key)?playsinline=1" allow="autoplay; encrypted-media; picture-in-picture" allowfullscreen></iframe>
        </body>
        </html>
        """
        loadingIndicator.startAnimating()
        webView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
    }

    private func openInYouTube() {
        guard let url = trailer.watchURL else { return }
        UIApplication.shared.open(url)
    }

    private func showLoadError() {
        let alert = UIAlertController(
            title: "Can't play trailer",
            message: "Open it in YouTube instead?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open", style: .default) { [weak self] _ in
            self?.openInYouTube()
        })
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension TrailerViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        showLoadError()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        showLoadError()
    }
}
