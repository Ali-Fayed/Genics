//
//  HVC Table.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/03/2021.
//

import UIKit
import SafariServices

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case homeTableView:
            return 3
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case homeTableView:
            switch section {
            case 0:
                return viewModel.numberOfHomeTableCells
            default:
                return 1
            }
        case searchHistoryTableView:
            return viewModel.numberOfSearchHistoryCells
        case searchOptionsTableView :
            return viewModel.numberOfSearchOptionsCells
        default:
            return Int()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case homeTableView:
            let cell = tableView.dequeue() as HomeTableViewCell
            switch (indexPath.section) {
            case 0:
                cell.getData(model: viewModel.getHomeCellViewModel(at: indexPath))
            case 1:
                cell.getSeconSectionData()
            default:
                cell.getThirdSectionData()
            }
            return cell
        case searchHistoryTableView:
            let cell = tableView.dequeue() as SearchHstoryCell
            cell.getData(with: viewModel.getSearchHistoryCellViewModel(at: indexPath))
            return cell
        case searchOptionsTableView:
            let cell = tableView.dequeue() as SearchOptionsCell
            let searchText = searchController.searchBar.text
            cell.getData(with: viewModel.getSearchOptionsCellViewModel(at: indexPath), with: searchText!)
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case homeTableView:
            switch indexPath.section {
            case 0:
                viewModel.pushToDestinationVC(indexPath: indexPath)
            case 1:
                pushToRepoURLPage()
            default:
                break
            }
        case searchHistoryTableView:
            viewModel.passCellTextToSearchBar(at: indexPath, with: searchHistoryTableView, with: searchController)
            DispatchQueue.main.async {
                self.searchOptionsTableView.reloadData()
            }
        case searchOptionsTableView:
            guard let text = searchController.searchBar.text else { return }
            viewModel.saveSearchWord(text: text)
            viewModel.pushToDestinationSearchedVC(indexPath: indexPath, searchText: text)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableView {
        case searchOptionsTableView:
            cell.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                cell.alpha = 1
            })
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case homeTableView:
            switch section {
            case 0:
                return  viewModel.initTableViewHeaderInSection(with: Titles.featuresTitle, view: view)
            case 1:
                return  viewModel.initTableViewHeaderInSection(with: Titles.projectRepoTitle, view: view)
            default:
                return  viewModel.initTableViewHeaderInSection(with: Titles.state, view: view)
            }
        default:
            break
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case searchHistoryTableView:
            return Titles.recentSearch
        default:
            break
        }
        return String()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case homeTableView, searchHistoryTableView:
            return 40
        case searchOptionsTableView:
            return 0
        default:
            break
        }
        return CGFloat()
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch tableView {
        case searchHistoryTableView:
           return .delete
        default:
           return .none
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView {
        case homeTableView:
            break
        case searchHistoryTableView:
            if editingStyle == .delete {
                tableView.beginUpdates()
                switch indexPath.section {
                case 0:
                    viewModel.handleDelete(at: indexPath)
                default:
                    break
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                DispatchQueue.main.async {
                    if self.viewModel.searchHistory.isEmpty == true {
                        self.conditionLabel.isHidden = false
                    }
                    self.searchHistoryTableView.reloadData()
                }
            }
        default:
            break
        }
    }
    func pushToRepoURLPage () {
        let repoURL = "https://github.com/Ali-Fayed/Githubgenics"
        let safariVC = SFSafariViewController(url: URL(string: repoURL)!)
        present(safariVC, animated: true)
    }
}
