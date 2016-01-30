# Fetches the lyrics from Genius (formerly known as Rap Genius)
# Lyrics are stored accessed via the URL schema http://genius.com/ARTIST-SONG-lyrics
# They are inside //div[@class="lyrics"]//p[1], a div with the class "lyrics"
# Inside the p in the lyrics div the are in a tags
class Genius < Wiki
  def get_lyrics(artist, song)
    artist.tr!(' ', '-')
    song.tr!(' ', '-')

    res = fetch("http://genius.com/#{artist.downcase}-#{song.downcase}-lyrics")
    return nil unless res.is_a? Net::HTTPSuccess

    lyrics = Nokogiri::HTML(res.body).xpath('//div[@class="lyrics"]//p[1]')

    lyrics.inner_html.gsub!('<br>', "\r").gsub!(%r{</?[^>]+>}, '').delete!("\n")
  end
end