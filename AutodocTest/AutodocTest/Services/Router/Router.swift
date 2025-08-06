//
//  Router.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 06.08.2025.
//

import UIKit
import SafariServices

final class Router {
    func showShareAlert(with data: News, from vc: MainDisplaying) {
        guard let vc = vc as? UIViewController else {
            print("Error: vc is not UIViewController"); return
        }
        let sheet = AppActionSheet()
        sheet.configureUI(with: data)
        sheet.modalTransitionStyle = .crossDissolve
        sheet.modalPresentationStyle = .overFullScreen
        vc.present(sheet, animated: true)

        sheet.onDismissButtonTapped = {
            vc.dismiss(animated: true)
        }
    }

    func showURL(url: String, from vc: MainDisplaying) {
        guard let vc = vc as? UIViewController else {
            print("Error: vc is not UIViewController"); return
        }
        guard let url = URL(string: url) else { print("Invalid URL: \(url)"); return }
        let safariVC = SFSafariViewController(url: url)
        vc.present(safariVC, animated: true)
    }
}
