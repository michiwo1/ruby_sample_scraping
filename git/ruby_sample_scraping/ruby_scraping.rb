#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
 
#webに接続するためのライブラリ
require "open-uri"
#htmlの情報を取得するためのライブラリ
require "nokogiri"
#csvを出力するためのライブラリ
require 'csv'
 
#クレイピング対象のURL
url = "https://qiita.com/question-trend"

#取得するhtml用charset
charset = nil
 
html = open(url) do |page|
  #charsetを自動で読み込み、取得
  charset = page.charset
  #中身を読む
  page.read
end
 
# Nokogiri で切り分け
contents = Nokogiri::HTML.parse(html,nil,charset)

# <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなるらしい。。
contents.search('br').each { |n| n.replace("\n") }

# xpath + クラス名で絞る(※クラスの前に1つ以上の要素指定が必要, クラス名はシングルクォーテーションで囲う)
titles = []
contents.xpath("//a[@class='css-y5mpg1 e1c4qyq01']").map do |title|
  titles.push(title.text)
end

detail_urls = []
contents.xpath("//a[@class='css-y5mpg1 e1c4qyq01']").map do |detail_url|
  detail_urls.push(url + detail_url.attribute('href').value)
end

rows = [titles, detail_urls]

# csvで出力
CSV.open('target.csv', 'w') do |csv|
  rows.each do |row|
    csv << row
  end
end
