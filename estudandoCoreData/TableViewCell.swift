//
//  TableViewCell.swift
//  estudandoCoreData
//
//  Created by José João Silva Nunes Alves on 14/10/20.
//

import UIKit

class TableViewCell: UITableViewCell {

    var titulo: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        label.textColor = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var date: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        label.textColor = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        self.addSubview(titulo)
        self.addSubview(date)

        self.selectionStyle = .none

        NSLayoutConstraint.activate([
            titulo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titulo.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            date.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            date.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 10),
            date.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(title: String, date: String) {
        self.titulo.text = title
        self.date.text = date
    }

}
