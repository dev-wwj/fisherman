//
//  ActivityVC.swift
//  fisher
//
//  Created by wangwenjian on 2023/12/12.
//

import Foundation
import UIKit

enum SectionType:CaseIterable {
    case card
    case fall
}

class CollectionCellData: Hashable {
    static func == (lhs: CollectionCellData, rhs: CollectionCellData) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var identifier: String = ""
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
}

class CardCellData: CollectionCellData {
    var size: NSCollectionLayoutSize
    
    var layoutItem: NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: size)
    }
    
    init(idetifier: String, size: NSCollectionLayoutSize) {
        self.size = size
        super.init()
        self.identifier = idetifier
    }
}

class FallCellData: CollectionCellData {
  
    let height: CGFloat
    
    init(idetifier: String, height: CGFloat) {
        self.height = height
        super.init()
        self.identifier = idetifier

    }
    
}

class ActivityVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        _ = collectionView
        
        initDataSource()

        let cellCards = (1 ... 4).map({
            CardCellData(idetifier: "card\($0)", size: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.23), heightDimension: .fractionalHeight(1.0)))
        })
        
        let cellFalls = (0 ... 10).map {
            FallCellData(idetifier: "fall\($0)", height: 200 + CGFloat(arc4random() % 60))
        }
        
        snapshot.appendSections(SectionType.allCases)
        snapshot.appendItems(cellCards, toSection: .card)
        snapshot.appendItems(cellFalls, toSection: .fall)
        dataSource?.apply(snapshot)
        
    }
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, CollectionCellData>
    var dataSource: DataSource?
    
    var snapshot = NSDiffableDataSourceSnapshot<SectionType, CollectionCellData>()
    
    lazy var _Layout: UICollectionViewCompositionalLayout = { [unowned self] in
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 8
//        let topItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.absolute(200), heightDimension: NSCollectionLayoutDimension.absolute(20)), elementKind: "UICollectionView.Header", alignment: .top)
//        configuration.boundarySupplementaryItems = [topItem]
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnvironment in
            guard let sectionType = self.snapshot.sectionIdentifiers[sectionIndex] as? SectionType else {
                assert(false)
            }
            let items = self.snapshot.itemIdentifiers(inSection: sectionType)
            switch sectionType {
            case .card:
                let subitems = items.map { ele  in
                    (ele as? CardCellData)!.layoutItem
                }
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: subitems)
                group.interItemSpacing = .flexible(8)
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .fall:
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1000))
                let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { environment -> [NSCollectionLayoutGroupCustomItem] in
                    let containerWidth = (environment.container.effectiveContentSize.width - 8)
                    let columnCount =  2
                    let itemWidth = containerWidth / CGFloat(2)
                    var customItems = [NSCollectionLayoutGroupCustomItem]()
                    var offsetL: CGFloat = 0, offsetR: CGFloat = 0
                    for (i, v) in items.enumerated() {
                        if offsetL <= offsetR {
                            let cellHeight = (v as? FallCellData)?.height ?? 0
                            let frame = CGRect(x: 0, y: offsetL, width: itemWidth, height: cellHeight)
                            let leftItem = NSCollectionLayoutGroupCustomItem(frame: frame)
                            offsetL += leftItem.frame.height + 8
                            customItems.append(leftItem)
                        } else {
                            let cellHeight = (v as? FallCellData)?.height ?? 0 + 8
                            let frame = CGRect(x: itemWidth + 8, y: offsetR, width: itemWidth, height: cellHeight)
                            let rightItem = NSCollectionLayoutGroupCustomItem(frame: frame)
                            offsetR += rightItem.frame.height + 8
                            customItems.append(rightItem)
                        }
                    }
                    return customItems
                }
                group.interItemSpacing = .fixed(8)
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }, configuration: configuration)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: _Layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: "_cell")
        return collectionView
    }()
    
    func initDataSource() {

       let dataSource = DataSource(collectionView: collectionView) {[unowned self] collectionView, indexPath, itemIdentifier in
            guard let sectionType = snapshot.sectionIdentifiers[indexPath.section] as? SectionType else {
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "_cell", for: indexPath)
           (cell as? ActivityCell)?.cellData = itemIdentifier
            return cell
        }
        self.dataSource = dataSource
    }
    
}

extension ActivityVC: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var currentSnapshot = dataSource?.snapshot()
        let item = snapshot.itemIdentifiers(inSection: SectionType.allCases[indexPath.section])[indexPath.item]
        snapshot.deleteItems([item])
              // 应用更新后的快照
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
