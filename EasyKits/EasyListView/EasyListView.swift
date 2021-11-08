//
//  EasyListView.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/9/2.
//

import UIKit

// MARK: EasyListViewDataSource
public protocol EasyListViewDataSource: AnyObject {
    /// 每个分区对应的数据源
    func listView(_ listView: EasyListView, modelForSection section: Int) -> EasyListSectionModel?
    
    /// section总数
    func numberOfSections(in listView: EasyListView) -> Int
}

// MARK: EasyListViewDelegate
public protocol EasyListViewDelegate: AnyObject {
    func listView(_ listView: EasyListView, didSelect cellModel: EasyListCellModel)
}

extension EasyListViewDelegate {
    func listView(_ listView: EasyListView, didSelect cellModel: EasyListCellModel) { }
}

open class EasyListView: UITableView {
    public weak var scrollDelegateProxy: UIScrollViewDelegate? {
        didSet {
            assert(self.scrollDelegateProxy?.isEqual(self) != true, "此代理不能设置为是self")
        }
    }
    
    public weak var listDataSource: EasyListViewDataSource?
    
    public weak var listDelegate: EasyListViewDelegate?
    
    fileprivate lazy var register: EasyListViewRegister = {
        let register = EasyListViewRegister(tableView: self)
        return register
    }()
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
        
        if #available(iOS 15, *) {
            self.sectionHeaderTopPadding = 0
        }
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK: Private Method
    fileprivate func sectionModel(atSection section: Int) -> EasyListSectionModel? {
        let sectionModel = self.listDataSource?.listView(self, modelForSection: section)
        if sectionModel?.section == nil {
            sectionModel?.section = section
        }
        if sectionModel?.tableView == nil {
            sectionModel?.tableView = self
        }
        return sectionModel
    }
    
    fileprivate func cellModel(atIndexPath indexPath: IndexPath) -> EasyListCellModel? {
        let sectionModel = self.sectionModel(atSection: indexPath.section)
        let cellModel = sectionModel?.cellModel(atIndex: indexPath.row)
        cellModel?.indexPath = indexPath
        return cellModel
    }
    
    fileprivate func headerModel(atSection section: Int) -> EasyListHeadFootModel? {
        return self.sectionModel(atSection: section)?.headerModel
    }
    
    fileprivate func footerModel(atSection section: Int) -> EasyListHeadFootModel? {
        return self.sectionModel(atSection: section)?.footerModel
    }
}

extension EasyListView: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewDidScroll?(scrollView)
    }
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewDidZoom?(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewWillBeginDragging?(scrollView)
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollDelegateProxy?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollDelegateProxy?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollDelegateProxy?.viewForZooming?(in: scrollView)
    }
    
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.scrollDelegateProxy?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.scrollDelegateProxy?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    
    open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.scrollDelegateProxy?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }
    
    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewDidScrollToTop?(scrollView)
    }
    
    
    @available(iOS 11.0, *)
    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.scrollDelegateProxy?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}

extension EasyListView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellModel = self.cellModel(atIndexPath: indexPath) else {
            return
        }
        if cellModel.selectedHandler != nil {
            cellModel.selectedHandler?(cellModel)
            return
        }
        self.listDelegate?.listView(self, didSelect: cellModel)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.listDataSource?.numberOfSections(in: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = self.sectionModel(atSection: section)
        return sectionModel?.cellModelList.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = self.cellModel(atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        self.register.registerCell(cellModel: cellModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellID) as! EasyListViewCell
        cell.listView = self
        cell.bindCell(cellModel: cellModel)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellModel(atIndexPath: indexPath)?.cellHeight ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionModel(atSection: section)?.headHeight ?? EasyListHeadFootModel.minHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.sectionModel(atSection: section)?.footHeight ?? EasyListHeadFootModel.minHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerModel = self.sectionModel(atSection: section)?.headerModel else {
            return nil
        }
        self.register.registerHeaderFooter(viewModel: headerModel)
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerModel.viewID) as? EasyListHeaderFooterView
        view?.listView = self
        view?.bindView(model: headerModel)
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerModel = self.sectionModel(atSection: section)?.footerModel else {
            return nil
        }
        self.register.registerHeaderFooter(viewModel: footerModel)
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerModel.viewID) as? EasyListHeaderFooterView
        view?.bindView(model: footerModel)
        return view
    }
}
