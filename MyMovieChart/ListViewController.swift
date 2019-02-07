//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by 윤성호 on 07/02/2019.
//  Copyright © 2019 윤성호. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    // 튜플 아이템으로 구성된 데이터 세트
    var dataset = [
        ("다크나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다.", "2008-09-04", 8.95),
        ("호우시절", "때를 알고 내리는 좋은 비", "2009-10-08", 7.31),
        ("말할 수 없는 비밀", "여기서 너까지 다섯 걸음", "2015-05-07", 9.19)
    ]
    
    // 테이블 뷰를 구성할 리스트 데이터
    lazy var list : [MovieVO] = {
        
        var datalist = [MovieVO]()
        
        for (title, desc, opendate, rating) in self.dataset {
            
            let mvo = MovieVO()
            
            mvo.title = title
            mvo.description = desc
            mvo.opendate = opendate
            mvo.rating = rating
            
            datalist.append(mvo)
        }
        
        return datalist
    }()
    /**
     lazy 키워드
         1. lazy키워드를 붙여서 변수를 정의하면 참조되는 시점에 맞추어 초기화되므로 메모리 낭비를 줄임
         2. 다른 프로퍼티를 참조하기 위해
     */
    
    // 뷰 컨트롤러가 초기화되면서 뷰가 메모리에 로딩될 때 호출되는 메소드
    override func viewDidLoad() {
    }
    
    // 테이블 뷰 행의 개수를 반환하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 테이블 뷰 행을 구성하는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 주어진 행에 맞는 데이터 소스를 읽어온다
        let row = self.list[indexPath.row]  // indexPath.row : 행 번호
        
        //NSLog("\(row.title)---")

        // 테이블 셀 객체를 직접 생성하는 대신 큐로부터 가져온다
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        cell.textLabel?.text = row.title

        return cell
    }
    
    // 데이블 셀을 선택했을때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다.")
    }
    
}
