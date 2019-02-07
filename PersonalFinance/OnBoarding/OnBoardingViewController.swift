//
//  OnBoardingViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 06/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIPageViewController ,UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil }
        guard viewControllerList.count > previousIndex else {return nil }
        return viewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = vcIndex +  1
        
        guard viewControllerList.count != nextIndex else {return nil }
        guard viewControllerList.count > nextIndex else {return nil }
        return viewControllerList[nextIndex]
        
        
        
    }
    
    
    lazy var viewControllerList : [UIViewController] =
        {
            let sb = UIStoryboard(name: "OnBoarding", bundle: nil)
            let vc1 = sb.instantiateViewController(withIdentifier: "StepOne")
            let vc2 = sb.instantiateViewController(withIdentifier: "StepTwo")
            let vc3 = sb.instantiateViewController(withIdentifier: "StepThree")
            
            return [vc1,vc2,vc3]
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        
        if let FirstViewController = viewControllerList.first
        {
            self.setViewControllers([FirstViewController], direction: .forward, animated: true, completion: nil)
            
        }
    }
    
}
