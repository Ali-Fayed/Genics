//
//  FailView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/10/2021.
//

import UIKit
// import ReSwiftRouter
class CustomFailScreen: UIView {
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var messageLAbel: UILabel!
    var message: String? = "please try again"
    var handler: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setViewData(handler: @escaping () -> Void) {
        self.messageLAbel.text = message
        self.handler = handler
    }
    @IBAction func reloadAction(_ sender: UIButton) {
        handler?()
    }
    func getFromNib<T>(view: T) -> T {
        let nibName = String(describing: type(of: view))
        let viewFromNib: T = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
        return viewFromNib
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.removeFromSuperview()
    }
}
extension UIViewController {
    private struct Holder {
        static var myComputedProperty: CustomFailScreen?
    }
   var customFailureView: CustomFailScreen? {
        get {
            return Holder.myComputedProperty
        }
        set(newValue) {
            Holder.myComputedProperty = newValue
        }
    }
    func showFailViewText(to superView: UIView, targetView: UIView, error: ApiError, handler: @escaping () -> Void) {
        showFailView(to: superView, targetView: targetView, error: error, handler: handler)
        customFailureView?.reloadBtn.isHidden = true
        customFailureView?.statusImgView.isHidden = true

    }
    func showFailView(to superView: UIView, targetView: UIView, error: ApiError, handler: @escaping () -> Void) {
        if self.customFailureView == nil {
            self.customFailureView = Bundle.main.loadNibNamed("CustomFailScreen", owner: nil, options: nil)?.first as? CustomFailScreen
        }
        customFailureView?.setViewData(handler: handler)
        customFailureView?.frame = targetView.frame
        customFailureView?.backgroundColor = .clear
        switch error.code {
        case .noConnetion:
            customFailureView?.statusImgView.image = #imageLiteral(resourceName: "bag")
            customFailureView?.reloadBtn.isHidden =  false
        default:
            customFailureView?.statusImgView.image = #imageLiteral(resourceName: "bag")
            customFailureView?.reloadBtn.isHidden = true
        }
        if let errorDescription = error.code?.errorDescription {
            customFailureView?.messageLAbel.text = errorDescription
        }else if let errorDescription = error.message {
            customFailureView?.messageLAbel.text = errorDescription
        }
        superView.addSubview(customFailureView!)
    }
    func hideFailView () {
        self.customFailureView?.removeFromSuperview()
    }
}
