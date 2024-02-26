//
//  FilterContainerViewController.swift
//
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import UIKit
import Combine
import SmilesUtilities

public final class FilterContainerViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.fontTextStyle = .smilesHeadline2
            titleLabel.text = FilterLocalization.filter.text
        }
    }
    @IBOutlet private weak var clearAllButton: UIButton! {
        didSet {
            clearAllButton.fontTextStyle = .smilesTitle1
            clearAllButton.setTitle(FilterLocalization.clearAll.text, for: .normal)
        }
    }
    @IBOutlet private weak var filterLabel: UILabel! {
        didSet {
            filterLabel.fontTextStyle = .smilesTitle3
            filterLabel.text = FilterLocalization.filtersSelected.text
        }
    }
    @IBOutlet private weak var filterCountLabel: UILabel! { didSet { filterCountLabel.fontTextStyle = .smilesTitle3 } }
    @IBOutlet private weak var applyLabel: UILabel! {
        didSet {
            applyLabel.fontTextStyle = .smilesTitle1
            applyLabel.text = FilterLocalization.apply.text
        }
    }
    @IBOutlet private weak var viewFilter: UIView!
    @IBOutlet private weak var segmentControlContainerView: UIView!
    @IBOutlet private weak var segmentController: UISegmentedControl!
    @IBOutlet private weak var buttomView: UIView!
    @IBOutlet private weak var dismissButton: UIButton! {
        didSet { dismissButton.setImage(UIImage(resource: .closeButton), for: .normal) }
    }
    @IBOutlet private weak var numberOfFiltersStackView: UIStackView! {
        didSet {
            numberOfFiltersStackView.isHidden = true
        }
    }
    
    // MARK: - Properties
    let filterViewController = SortViewController.create()
    let choicesViewController  = FilterChoicesViewController.create()
    var viewModel: FilterContainerViewModel!
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        bindFilterData()
        bindFilterCuision()
        if viewModel.filterContentType == .food {
            viewModel.fetchFilters()
        } else {
            viewModel.fetchOffersFilters()
        }
        configSegmentUI()
        bindCountFilters()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filterViewController.view.frame = self.containerView.bounds
        choicesViewController.view.frame = self.containerView.bounds
    }
    
    // MARK: - Button Actions
    @IBAction private func filterTapped(_ sender: Any) {
        viewModel.getFiltersDictionary()
        dismiss()
        
    }
    
    @IBAction private func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func clearAllTapped(_ sender: Any) {
        filterViewController.clearData()
        choicesViewController.clearSelectedFilters()
        viewModel.clearData()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if segmentController.selectedSegmentIndex == 0 {
            filterViewController.view.alpha = 0
            containerView.bringSubviewToFront(filterViewController.view)
            fadeIn(view: filterViewController.view)
        } else {
            choicesViewController.view.alpha = 0
            containerView.bringSubviewToFront(choicesViewController.view)
            fadeIn(view: choicesViewController.view)
        }
    }
    
    // MARK: - Functions
    private func configSegmentUI() {
        let fontStyle = UIFont.preferredFont(forTextStyle: .headline)
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.foodEnableColor, NSAttributedString.Key.font: fontStyle], for: .selected)
        
        let normalColor = UIColor.black.withAlphaComponent(0.6)
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalColor, NSAttributedString.Key.font: fontStyle], for: .normal)
        viewFilter.layer.cornerRadius = 24
        clearAllButton.titleLabel?.textColor = .foodEnableColor
        buttomView.addShadowToSelf(offset: CGSize(width: 0, height: -1), color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2), radius: 1.0, opacity: 5)
    }
    
    private func configSegment(_ titles: [FilterStrategy]) {
        if titles.count == 2 {
            segmentControlContainerView.isHidden = false
            segmentController.isHidden = false
        } else {
            segmentControlContainerView.isHidden = true
            segmentController.isHidden = true
        }
        
        for item in titles {
            switch item {
            case .cusines(title: let title):
                segmentController.setTitle(title, forSegmentAt: 1)
                containerView.addSubview(choicesViewController.view)
                containerView.bringSubviewToFront(choicesViewController.view)
                
            case .filter(title: let title):
                segmentController.setTitle(title, forSegmentAt: 0)
                containerView.addSubview(filterViewController.view)
                containerView.bringSubviewToFront(filterViewController.view)
            }
        }
    }
    
    private func bindData() {
        viewModel.statePublisher.sink { [weak self] states in
            guard let self else {
                return
            }
            switch states {
            case .showError(message: let message):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showAlertWithOkayOnly(message: message) { _ in 
                        self.dismiss()
                    }
                }
                
            case .filters(let filters, let isDummy):
                self.filterViewController.setupSections(filterModel: FilterUIModel(sections: filters), isDummy: isDummy)
            case .cuisines(let cuisines):
                self.choicesViewController.updateData(section: cuisines)
            case .segmentTitles(titles: let titles):
                self.configSegment(titles)
            }
        }.store(in: &cancellable)
    }
    
    private func bindCountFilters() {
        viewModel.$countOfSelectedFilters.sink { [weak self] count in
            self?.filterCountLabel.text = "\(count)"
            self?.numberOfFiltersStackView.isHidden = (count == 0) ? true : false
        }
        .store(in: &cancellable)
    }
    
    private func bindFilterCuision() {
        choicesViewController.selectedFilter.sink { [weak self] indexPath in
            guard let self else {
                return
            }
            self.viewModel.updateCusines(with: indexPath)
            self.viewModel.updateSelectedFilters()
        }.store(in: &cancellable)
    }
    
    private func bindFilterData() {
        filterViewController.selectedFilter.sink { [weak self] indexPath in
            guard let self else {
                return
            }
            self.viewModel.updateFilter(with: indexPath)
            self.viewModel.updateSelectedFilters()
        }.store(in: &cancellable)
    }
    private func fadeIn(view: UIView, duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) {
            view.alpha = 1.0
        }
    }
}

extension FilterContainerViewController {
    static public func create() -> FilterContainerViewController {
        let viewController = FilterContainerViewController(nibName: String(describing: FilterContainerViewController.self), bundle: .module)
        return viewController
    }
}

