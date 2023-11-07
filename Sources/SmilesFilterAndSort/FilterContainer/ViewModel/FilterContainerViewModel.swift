//
//  File.swift
//
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation
import Combine
import SmilesUtilities

public protocol SelectedFiltersDelegate: AnyObject {
    func didSetFilters(_ filters: [FilterValue])
    func didSetFilterResponse(_ data: Data?)
}

final class FilterContainerViewModel {
    
    // MARK: - Properties
    private var filtersList: [FiltersList] = []
    private var originalFiltersList: [FiltersList] = []
    private var selectedFilter: [FilterValue] = []
    private var cancellable = Set<AnyCancellable>()
    private let useCase: FilterContainerUseCaseType
    private var stateSubject = PassthroughSubject<State, Never>()
    var filters: [FilterSectionUIModel] = []
    var cuisines: FilterSectionUIModel = .init()
    var segmentTitles: [FilterStrategy] = []
    public weak var delegate: SelectedFiltersDelegate?
    @Published var countOfSelectedFilters = 0
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(useCase: FilterContainerUseCaseType) {
        self.useCase = useCase
    }
    
    // MARK: - Functions
    func fetchFilters() {
        stateSubject.send(.showLoader)
        useCase.statePublisher.sink { [weak self] response in
            guard let self else {
                return
            }
            self.stateSubject.send(.hideLoader)
            switch response {
            case .error(let message):
                self.stateSubject.send(.showError(message: message))
            case .listFilters(let filters):
                self.filtersList = filters.filtersList ?? []
                var list = filters
                let unselectedList = list.setUnselectedValues()
                self.originalFiltersList = unselectedList ?? []
                self.updateSelectedFilters()
            case .values(let filters, let cusines):
                self.configSegmentTitles(filters: filters, cuisines: cusines)
                self.stateSubject.send(.filters(filters.sections))
                self.stateSubject.send(.cuisines(cuisines: cusines.sections.first ?? .init()))
            }
        }
        .store(in: &cancellable)
        useCase.fetchFilters()
    }
    
    func clearData() {
        filtersList = originalFiltersList
        updateSelectedFilters()
    }
    
    private func configSegmentTitles(filters: FilterUIModel, cuisines: FilterUIModel) {
        var segmentTitles: [FilterStrategy] = []
        if let title = cuisines.title, !title.isEmpty {
            segmentTitles.append(.cusines(title: title))
        }
        
        if let title = filters.title, !title.isEmpty {
            segmentTitles.append(.filter(title: title))
        }
        
        stateSubject.send(.segmentTitles(titles: segmentTitles))
    }
    
    func updateFilter(with index: IndexPath) {
        guard let filterIndex = useCase.getFilterIndex(),
              let countOfItems = filtersList[safe: filterIndex]?.filterTypes?[safe: index.section]?.filterValues?.count,
              let isMultiSelection = filtersList[safe: filterIndex]?.filterTypes?[safe: index.section]?.isMultipleSelection
        else {
            return
        }
        
        if isMultiSelection {
            filtersList[filterIndex].filterTypes?[index.section].filterValues?[index.row].toggle()
        } else {
            for i in 0..<countOfItems {
                i != index.row ? filtersList[filterIndex].filterTypes?[index.section].filterValues?[i].setUnselected() : ()
            }
            filtersList[filterIndex].filterTypes?[index.section].filterValues?[index.row].toggle()
        }
    }
    
    func updateCusines(with index: IndexPath) {
        guard let filterIndex = useCase.getCusinesIndex(),
              let isEmpty = filtersList[filterIndex].filterTypes?.first?.filterValues?.isEmpty,
              !isEmpty
        else {
            return
        }
        filtersList[filterIndex].filterTypes?[0].filterValues?[index.row].toggle()
    }
    
    func updateSelectedFilters() {
        countOfSelectedFilters = 0
        selectedFilter = []
        
        func processFilterTypes(filterIndex: Int?) {
            guard let filterIndex, let filterTypes = filtersList[filterIndex].filterTypes else {
                return
            }
            filterTypes.forEach { item in
                let selected = (item.filterValues ?? []).filter { $0.isSelected == true }
                countOfSelectedFilters += selected.count
                selectedFilter.append(contentsOf: selected)
            }
        }
        
        processFilterTypes(filterIndex: useCase.getFilterIndex())
        processFilterTypes(filterIndex: useCase.getCusinesIndex())
    }
    
    func getFiltersDictionary() {
        let responseData = FilterDataModel(extTransactionID: "", filtersList: filtersList).toData
        delegate?.didSetFilters(selectedFilter)
        delegate?.didSetFilterResponse(responseData)
    }
    
    
}


extension FilterContainerViewModel {
    enum State {
        case showLoader
        case hideLoader
        case showError(message: String)
        case filters([FilterSectionUIModel])
        case cuisines(cuisines: FilterSectionUIModel)
        case segmentTitles(titles: [FilterStrategy])
    }
}

