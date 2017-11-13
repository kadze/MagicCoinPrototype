//
//  InviteViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/21/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var guideContainerView: UIView!
    
    var pageController: UIPageViewController!
    var viewControllers: [UIViewController]!
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGuidePageController()
        customizeBackBarButton()
        autologin()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    //MARK:- Actions
    
    @IBAction func onLoginButton(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func onRegistrationButton(_ sender: Any) {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    //MARK:- Private
    
    private func customizeBackBarButton() {
        let yourBackImage = #imageLiteral(resourceName: "BackButton")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = nil
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func autologin(restoreSession: Bool = true) {
//        if UserManager.shared.canRestoreSession && restoreSession {
//            UserManager.shared.restoreUserSession({ [weak self] (result) in
//                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
//                }, {  [weak self] (error) in
//                    self?.autologin(restoreSession: false)
//            })
//        }
        
        
//        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
}

//MARK:- Page controller
extension InviteViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == viewControllers.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK: Private
    fileprivate func setupGuidePageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        viewControllers = [GuideChildViewController(image: #imageLiteral(resourceName: "Guide0")),
                           GuideChildViewController(image: #imageLiteral(resourceName: "Guide1")),
                           GuideChildViewController(image: #imageLiteral(resourceName: "Guide2")),
                           GuideChildViewController(image: #imageLiteral(resourceName: "Guide3"))
        ]
        
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        pageController.dataSource = self
        
        addChildViewController(pageController)
        let pageControllerView = pageController.view!
        guideContainerView.addSubview(pageControllerView)
        pageControllerView.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate(
            [pageControllerView.leadingAnchor.constraint(equalTo: guideContainerView.layoutMarginsGuide.leadingAnchor),
             pageControllerView.trailingAnchor.constraint(equalTo: guideContainerView.layoutMarginsGuide.trailingAnchor),
             pageControllerView.bottomAnchor.constraint(equalTo: guideContainerView.layoutMarginsGuide.bottomAnchor),
             pageControllerView.topAnchor.constraint(equalTo: guideContainerView.layoutMarginsGuide.topAnchor)]
        )
        
        pageController.didMove(toParentViewController: self)
    }
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if viewControllers.count == 0 || index >= viewControllers.count {
            return nil
        }
        
        return viewControllers[index]
    }
    
    fileprivate func indexOfViewController(_ viewController: UIViewController) -> Int {
        return viewControllers.index(of: viewController) ?? NSNotFound
    }

}
