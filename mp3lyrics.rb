#!/usr/bin/env ruby
require 'mp3info'
require 'require_all'

require_all './lib/'

def set_lyrics(mp3, lyrics)
  mp3.tag2.USLT = lyrics
end

def search_lyrics(file)
  Mp3Info.open(file) do |mp3|
    artist = mp3.tag.artist || mp3.tag1.artist || mp3.tag2.artist
    title = mp3.tag.title || mp3.tag1.title || mp3.tag2.title
    if artist.nil? || title.nil?
      puts "Skipping song because title or artist is not set...\n\r"
      next
    end
    puts "Fetching lyrics for #{artist} - #{title}"
    # Either no tag is set, the mp3 file has no USLT tag or we override anyway
    if !mp3.hastag2? || (mp3.hastag2? && !mp3.tag2.key?('USLT')) || override
      lyrics = nil
      if wiki_to_use.nil? || wiki_to_use == 'lyricwikia'
        lyrics = LyricWikia.new.get_lyrics(artist, title)
      end
      if wiki_to_use.nil? || wiki_to_use == 'genius'
        lyrics = Genius.new.get_lyrics(artist, title) if lyrics.nil?
      end
      if wiki_to_use.nil? || wiki_to_use == 'metrolyrics'
        lyrics = MetroLyrics.new.get_lyrics(artist, title) if lyrics.nil?
      end
      if wiki_to_use.nil? || wiki_to_use == 'azlyrics'
        lyrics = AZLyrics.new.get_lyrics(artist, title) if lyrics.nil?
      end
      if wiki_to_use.nil? || wiki_to_use == 'swiftlyrics'
        lyrics = SwiftLyrics.new.get_lyrics(artist, title) if lyrics.nil?
      end
      if lyrics.nil?
        puts "Did not find any lyrics\n\r"
      else
        puts "Lyrics found\n\r"
        set_lyrics(mp3, lyrics)
      end
    else
      puts "Skipping #{artist} - #{title} because lyrics are already set"
    end
  end
end

files = Dir.glob("#{dir}/**/*")
files.each do |file|
  filename = File.extname(file)
  next unless filename == '.mp3'
  search_lyrics(file)
end
