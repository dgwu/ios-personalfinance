//
//  PresentationManager.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 04/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class PresentationManager: NSObject {
}
    //MARK: - UIViewControllerTransitionDelegate
    extension PresentationManager: UIViewControllerTransitioningDelegate{
        
        func presentationController(forPresented presented: UIViewController,
                                    presenting: UIViewController?,
                                    source: UIViewController) -> UIPresentationController? {
            let presentationController = PresentationController(presentedViewController: presented,
                                                                presenting: presenting)
            return presentationController
        }
}
