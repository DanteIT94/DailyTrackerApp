//
//  UIPageViewController.swift
//  ToDoTracker
//
//  Created by Денис on 24.07.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        let firstPage = CustomPageViewController(image: UIImage(named: "PageImageView1"))
        let secondPage = CustomPageViewController(image: UIImage(named: "PageImageView2"))
        return [firstPage, secondPage]
    }()
    
    let pageTexts = [
        NSLocalizedString("firstOnboardingTitle", comment: ""),
        NSLocalizedString("secondOnboardingTitle", comment: "")]
    var currentPageIndex = 0
    
    lazy var onboardingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .YPBlack
        pageControl.pageIndicatorTintColor = .YPGrey
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    lazy var onboardingButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("onboardingButton", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .YPBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToMainScreenButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        configLayout()
        updateOnboardingLabel()
    }
    
    //MARK: - Private Methods
    private func configLayout() {
        
        [onboardingButton, pageControl, onboardingLabel].forEach{
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            onboardingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingLabel.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -130),
            onboardingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 8),
            pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -24),
            //Кнопка
            onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        
    }
    
    private func updateOnboardingLabel() {
        guard currentPageIndex >= 0, currentPageIndex < pageTexts.count else
        { return }
        onboardingLabel.text = pageTexts[currentPageIndex]
    }
    
    @objc func goToMainScreenButtonTapped() {
        UserDefaults.standard.set(true, forKey: "hasCompletedTransition")
        switchToTabBarController()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid config")
            return
        }
        let tabBarController = TabBarViewController()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = tabBarController
            UIView.setAnimationsEnabled(oldState)
        }, completion: nil)
    }
    
}

//MARK: -UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    //Возвращает предыдущий контроллер
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if viewControllerIndex == 0 {
            return pages.last
        }
        
        let previousIndex = viewControllerIndex - 1
        return pages[previousIndex]
    }
    
    //Возвращает следующий вьюконтроллер
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == pages.count - 1 {
            return pages.first
        }
        
        let nextIndex = viewControllerIndex + 1
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            currentPageIndex = currentIndex
            updateOnboardingLabel()
            pageControl.currentPage = currentIndex
        }
    }
    
}
