//
//  File.swift
//  
//
//  Created by Wilson Desimini on 8/22/20.
//

#if canImport(UIKit)
import UIKit

open class FadeableViewController: UIViewController {
    public let targetBackgroundColor: UIColor
    private let animationDuration: TimeInterval
    private weak var transitionLayerView: UIView!
    private weak var nextViewController: UIViewController?
    
    public init(targetBackgroundColor: UIColor, animationDuration: TimeInterval = 0.4) {
        self.targetBackgroundColor = targetBackgroundColor
        self.animationDuration = animationDuration
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = targetBackgroundColor
        addTransitionLayerView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if nextViewController == nil {
            view.bringSubviewToFront(transitionLayerView)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if nextViewController != nil {
            fadeFromPresentedController()
        } else {
            fadeFromPresentingController()
        }
    }
    
    open func presentWithFade(_ fadeableController: FadeableViewController) {
        nextViewController = fadeableController
        
        fadeToPresentedController(fadeableController) {
            self.present(fadeableController, animated: false)
        }
    }
    
    open func dismissWithFade() {
        if let _ = presentingViewController as? FadeableViewController {
            fadeToPresentingController()
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    
    private func addTransitionLayerView(alpha: CGFloat = 1) {
        let tlv = UIView()
        tlv.translatesAutoresizingMaskIntoConstraints = false
        tlv.alpha = alpha
        tlv.backgroundColor = view.backgroundColor
        view.addSubview(tlv)
        tlv.pinTo(view)
        transitionLayerView = tlv
    }
    
    // MARK: Fade Transition Lifecycle

    // from presenting controller
    
    private func fadeFromPresentingController() {
        UIView.performAnimations([
            { self.transitionLayerView.alpha = 0 }
        ], duration: animationDuration) {
            self.transitionLayerView.removeFromSuperview()
            self.transitionLayerView = nil
        }
    }
    
    // to presented controller
    
    private func fadeToPresentedController(_ controller: FadeableViewController, completion: @escaping () -> ()) {
        addTransitionLayerView(alpha: 0)
        
        UIView.performAnimations([
            { self.transitionLayerView.alpha = 1 },
            { self.transitionLayerView.backgroundColor = controller.targetBackgroundColor }
        ], duration: animationDuration) {
            completion()
        }
    }
    
    // from presented controller
    
    private func fadeFromPresentedController() {
        UIView.performAnimations([
            { self.transitionLayerView.backgroundColor = self.targetBackgroundColor },
            { self.transitionLayerView.alpha = 0 }
        ], duration: animationDuration) {
            self.transitionLayerView.removeFromSuperview()
            self.transitionLayerView = nil
            self.nextViewController = nil
        }
    }
    
    // to presenting controller
    
    private func fadeToPresentingController() {
        addTransitionLayerView(alpha: 0)
        
        UIView.performAnimations([
            { self.transitionLayerView.alpha = 1 }
        ], duration: animationDuration) {
            self.dismiss(animated: false)
        }
    }
}
#endif
