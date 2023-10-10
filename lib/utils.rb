require 'tty-link'
require 'nokogiri'

module Utils
  def self.url_text(text, url)
    TTY::Link.link_to(text, url)
  end

  def self.html_to_text(html_text)
    Nokogiri::HTML(html_text).text
  end

  def self.display_by_reader(content)
    system("echo '#{content}' | less")
  end

  def self.open_url(url)
    cmd = case RbConfig::CONFIG['host_os']
          when /mswin|mingw|cygwin/ then 'start '
          when /darwin/ then 'open '
          when /linux|bsd/ then 'xdg-open '
          else raise 'No OS detected'
          end

    system cmd + url
  end
end
