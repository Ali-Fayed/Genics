//
//  UVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

extension UsersViewController : UITableViewDelegate {
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch tableView {
        case self.tableView:
            let identifier = "\(String(describing: index))" as NSString
            return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { [weak self]_ in
                let bookmarkAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                    self?.viewModel.saveUserToBookmarks(indexPath: indexPath)
                }
                let safariAction = UIAction(
                    title: Titles.openInSafari,
                    image: UIImage(systemName: "link")) { _ in
                        self?.openInSafari(indexPath: indexPath)
                    }
                let shareAction = UIAction(
                    title: Titles.share,
                    image: UIImage(systemName: "square.and.arrow.up")) { _ in
                        self?.shareUser(indexPath: indexPath)
                    }
                let saveImage = UIAction(
                    title: Titles.saveImage,
                    image: UIImage(systemName: "photo")) { _ in
                        self?.saveeImage(indexPath: indexPath)
                    }
                return UIMenu(title: "", image: nil, children: [safariAction, bookmarkAction, saveImage, shareAction])
            }
        default:
            break
        }
        return UIContextMenuConfiguration()
    }
    //MARK: - LongPress Actions
    func openInSafari (indexPath: IndexPath) {
        let usersURLstring = self.viewModel.getUsersCellsViewModel(at: indexPath).userURL
        guard let usersURL = URL(string: usersURLstring) else {return}
        let safariVC = SFSafariViewController(url: usersURL)
        self.present(safariVC, animated: true)
    }
    func shareUser (indexPath: IndexPath) {
        let avatarUrl = self.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
        let usersURL = self.viewModel.getUsersCellsViewModel(at: indexPath).userURL
        let fileUrl = URL(string: avatarUrl)
        let data = try? Data(contentsOf: fileUrl!)
        let image = UIImage(data: data!)
        let sheetVC = UIActivityViewController(activityItems: [image!,usersURL], applicationActivities: nil)
        HapticsManger.shared.selectionVibrate(for: .medium)
        self.present(sheetVC, animated: true)
    }
    func saveeImage (indexPath: IndexPath) {
        let usersAvatarURL = self.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
        let fileUrl = URL(string: usersAvatarURL)
        let data = try? Data(contentsOf: fileUrl!)
        let image = UIImage(data: data!)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }
}
