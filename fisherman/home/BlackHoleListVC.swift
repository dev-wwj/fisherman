//
//  BlackHoleListVC.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/22.
//

import Foundation
import UIKit
import AMapSearchKit
import Kingfisher

class BlackHoleListVC: UIViewController {
    
    var searchHandle: POISearchHandle! {
        didSet {
            searchHandle.addDelegate(self)
        }
    }
    
    weak var superVC: UIViewController? {
        didSet {
            superVC?.addChild(self)
            superVC?.view.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalTo(122)
                make.height.equalTo(36 + 30)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        _ = tableView
        _ = drawerButton
    }
    
    private lazy var tableContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .black
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0))
        }
        return container
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white.withAlphaComponent(0.2)
        tableView.register(_Cell.self, forCellReuseIdentifier: "_Cell")
        tableContainer.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        }
        return tableView
    }()
    
    lazy var drawerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage("outline_expand_more_black_36pt_".image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.gray
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(tableContainer.snp.bottom)
        }
        button.tapAction {[weak self] _ in
            self?.show()
        }
        return button
    }()
    
    func show(){
        view.snp.updateConstraints { make in
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight * 0.618)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension BlackHoleListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "_Cell", for: indexPath)
        (cell as? _Cell)?.poi = searchHandle.results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHandle.results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

extension BlackHoleListVC: POISearchDelegate {
    func search(handle: POISearchHandle, new value: [AMapPOI]) {
        tableView.reloadData()
    }
    
}

fileprivate class _Cell: UITableViewCell {
   
    static let colors: [UIColor] = [0x2288ff.color, 0x88FF22.color, 0xFE2288.color]
    
    var color: UIColor? {
        didSet {
            iv.backgroundColor = color
        }
    }
    
    var poi: AMapPOI? {
        didSet {
            titleL.text = poi?.name
            detailL.text = poi?.address
            iv.text = poi?.name.prefix(2).description
            if let imgs = poi?.images,
               let img = imgs.first {
                iv.kf.setImage(with: URL(string: img.url ?? ""))
            }
            color = _Cell.colors[Int(poi?.uid.last?.utf8.first as? UInt8 ?? 0)%3]
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _ = [iv, titleL, detailL]
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iv: TImageView = {
        let imageView = TImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 54, height: 54))
        }
        return imageView
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.textColor = .white
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(iv).offset(3)
            make.left.equalTo(iv.snp.right).offset(10)
            make.right.equalTo(-20)
        }
        return label
    }()
    
    lazy var detailL: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.6)
        label.font = 14.font
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(titleL.snp.bottom).offset(5)
            make.left.equalTo(iv.snp.right).offset(10)
            make.right.equalTo(-20)
        }
        return label
    }()
    
}
