#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
 
#webに接続するためのライブラリ
require "open-uri"
#htmlの情報を取得するためのライブラリ
require "nokogiri"
#csvを出力するためのライブラリ
require 'csv'
 
#クレイピング対象のURL
url = "https://zenn.dev"

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

# <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなるらしい。
contents.search('br').each { |n| n.replace("\n") }

titles = []
contents.xpath("//div/article/div/a/h2").map do |title|
  titles.push(title.text)
end

detail_urls = []
contents.xpath("//div/article/div/a[@class='ArticleList_link__1sza2']").map do |detail_url|
  detail_urls.push(url + detail_url.attribute('href').value)
end

rows = [titles, detail_urls]

# csvで出力
CSV.open('target.csv', 'w') do |csv|
  rows.each do |row|
    csv << row
  end
end

