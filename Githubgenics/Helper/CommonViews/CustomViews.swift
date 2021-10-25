//
//  CustomViews.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/10/2021.
//

import UIKit
import MBProgressHUD
import CleanyModal
class CustomViews {
    static let shared = CustomViews()
    func showAlert(message: String, title: String) {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    func setupSearchController (search: UISearchController, viewController: UIViewController) {
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        viewController.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        viewController.navigationItem.searchController = search
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    // Handle Refresh
    @objc func refreshTable(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }

}

extension UIViewController {
    func dismissButton() {
       let button = UIButton(type: .system)
       button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
       button.setTitle("Back", for: .normal)
       button.sizeToFit()
       button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
       let backButton = UIBarButtonItem(customView: button)
       navigationItem.leftBarButtonItem = backButton
   }
    func setupSearchController (search: UISearchController, viewController: UIViewController) {
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        viewController.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        viewController.navigationItem.searchController = search
    }
    func showTableViewSpinner (tableView: UITableView) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    func showIndicator(withTitle title: String, and description: String) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.mode = .indeterminate
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func dismissView () {
    }
}
