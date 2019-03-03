//
//  DetailVIewController.swift
//  MyMovieChart
//
//  Created by 윤성호 on 02/03/2019.
//  Copyright © 2019 윤성호. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate{
    
    @IBOutlet var wv: WKWebView!    // 웹 뷰
    @IBOutlet var spinner: UIActivityIndicatorView! // 인디케이터 뷰
    
    // 목록 화면에서 전달하는 영화 정보를 받는 변수
    var mvo : MovieVO!
    
    // Called when web content begins to load in a web view.
    // 웹 뷰 로딩이 시작 될때 호출되는 메서드
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.spinner.startAnimating()
    }
    
    // Called when a web view receives a server redirect.
    // 웹 뷰 탐색이 완료되면 호출되는 메소드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.spinner.stopAnimating()
    }
    
    // Called when an error occurs while the web view is loading content.
    // 웹 뷰 로딩에 실패했을 때 호출되는 메소드
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        // 인디케이트 뷰 애니메이션 중지
        self.spinner.stopAnimating()
        
        // 알림
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다.", preferredStyle: .alert)
        
        let cancelBtn = UIAlertAction(title: "확인", style: .cancel){
            (_) in
            
            // 이전 화면으로
            _ = self.navigationController?.popViewController(animated: false)
        }
        
        alert.addAction(cancelBtn)
        self.present(alert, animated: false)
        
    }
    
    override func viewDidLoad() {
        
        self.wv.navigationDelegate = self
        
        // 넘어온 객체 확인
        NSLog("linkurl = \(self.mvo?.detail), title = \(self.mvo?.title)")
        
        // 네비게이션 바의 타이틀에 영화명을 출력
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        // 예외처리
        if let url = self.mvo?.detail {     // 상세보기 유무 체크
            
            if let urlObj = URL(string: url){   // URL 유형 체크
                
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
                
            }else {
                
                // url 유형이 아닐때 처리
                let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다.", preferredStyle: .alert)
                
                let cancelBtn = UIAlertAction(title: "확인", style: .cancel){
                    (_) in
                    
                    // 이전 페이지로
                    _ = self.navigationController?.popViewController(animated: false)
                }
                
                alert.addAction(cancelBtn)
                self.present(alert, animated: false)
            }
        } else {
            
            // 상세보기 url이 nil일때 처리
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다", preferredStyle: .alert)
            
            let cancelBtn = UIAlertAction(title: "확인", style: .cancel){
                (_) in
                
                // 이전 페이지로
                _ = self.navigationController?.popViewController(animated: false)
            }
            
            alert.addAction(cancelBtn)
            self.present(alert, animated: false, completion: nil)
        }
        
        
    }
    
    
}
