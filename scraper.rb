#!/usr/bin/env ruby

require "open-uri"
require "rubygems"
require "nokogiri"
require "pp"

base     = "http://j-lyric.net"
start    = base + "/artist/a0579b7/"
sleep    = 1 #sec
override = true

index_html = open(start)
index_doc = Nokogiri::HTML.parse(index_html, nil, 'utf-8')


p index_doc.title

titles = index_doc.css('.ttl > a')

titles.each do |title|
    id        = title["href"].split('/')[3].split('.')[0]
    lyric_url = base + title["href"]

    lyric_html = open(lyric_url)

    lyric_doc = Nokogiri::HTML.parse(lyric_html, nil, 'utf-8')

    p title.text + "    " + lyric_url
    lyric = lyric_doc.css('#Lyric')
    lyric.search('br').each do |br|
        br.replace("\n")
    end

    #p lyric.text
    File.write('out/' + id + '.txt', title.text + "\n--\n" + lyric.text)

    sleep(sleep)
end

