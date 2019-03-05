//
//  TheaterListController.swift
//  MyMovieChart
//
//  Created by 윤성호 on 04/03/2019.
//  Copyright © 2019 윤성호. All rights reserved.
//

import UIKit

class TheaterListController: UITableViewController {
    
    // API를 통해 불러온 데이터를 저장할 배열 변수
    var list = [NSDictionary]()
    
    // 읽어올 데이터의 시작위치
    var startPoint = 0
    
    override func viewDidLoad() {
        
        // api를 읽어오는 메소드 호출
        self.callTheaterAPI()
    }
    
    // 테이블 뷰의 행의 갯수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 테이블 셀의 구성 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // list배열에서 행에 맞는 데이터 정보
        let obj = self.list[indexPath.row]
        
        // 재사용 큐로부터 tCell 식별자에 맞는 셀 객체를 전달받음
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        
        cell.name.text = obj["상영관명"] as? String
        cell.addr.text = obj["소재지도로명주소"] as? String
        cell.tel.text = obj["연락처"] as? String
        
        return cell
    }
    
    // 영화관 정보 API를 읽어오는 메소드
    func callTheaterAPI() {
        
        let sList = 100
        let type = "json"
        
        // api URL형태
        let url : URL! = URL(string: "http://swiftapi.rubypaper.co.kr:2029/theater/list?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        
        do {
            
            // EUC-KR 인코딩
            let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
            
            let stringData = try NSString(contentsOf: url, encoding: encodingEUCKR)     // CFStringConvertEncodingToNSStringEncoding일 경우
            //let stringData = try NSString(contentsOf: url, encoding: 0x80_000_422)    // 0x80_000_422일 경우
            
            // apiData 확인
            NSLog("string data : \(stringData)")
            
            // EUC-KR -> UTF-8 로 인코딩
            let encoData = stringData.data(using: String.Encoding.utf8.rawValue)
            
            do {
                // Data 객체를 파싱하여 NSArray 객체로 변환
                let apiArray = try JSONSerialization.jsonObject(with: encoData!, options: []) as! NSArray
                
                // list에 담기
                for row in apiArray {
                    self.list.append(row as! NSDictionary)
                }
                
            } catch {   // 파싱하여 변환 실패
                
                let alert = UIAlertController(title: "오류", message: "데이터 분석이 실패하였습니다.", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "확인", style: .cancel)
                
                alert.addAction(cancel)
                self.present(alert, animated: false)
                
                // 읽어와야 할 다음 페이지의 데이터 시작 위치를 구해 저장해둔다.
                self.startPoint += sList
            }
            
        } catch {   // 인코딩 실패
            
            let alert = UIAlertController(title: "오류", message: "데이터를 불러오는데 실패하였습니다.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
        
    }
}
