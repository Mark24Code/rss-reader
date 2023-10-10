require 'colorize'

class String
  def red = colorize(self, "\e[1m\e[31m")
  def green = colorize(self, "\e[1m\e[32m")
  def dark_green = colorize(self, "\e[32m")
  def yellow = colorize(self, "\e[1m\e[33m")
  def blue = colorize(self, "\e[1m\e[34m")
  def dark_blue = colorize(self, "\e[34m")
  def purple = colorize(self, "\e[35m")
  def dark_purple = colorize(self, "\e[1;35m")
  def cyan = colorize(self, "\e[1;36m")
  def dark_cyan = colorize(self, "\e[36m")
  def pure = colorize(self, "\e[0m\e[28m")
  def bold = colorize(self, "\e[1m")
  def colorize(text, color_code) = "#{color_code}#{text}\e[0m"
end

class String
  def mv_up(n = 1)
    cursor(self, "\033[#{n}A")
  end

  def mv_down(n = 1)
    cursor(self, "\033[#{n}B")
  end

  def mv_fw(n = 1)
    cursor(self, "\033[#{n}C")
  end

  def mv_bw(n = 1)
    cursor(self, "\033[#{n}D")
  end

  def cls_upline
    cursor(self, "\e[K")
  end

  def cls
    # cursor(self, "\033[2J")
    cursor(self, "\e[H\e[2J")
  end

  def save_position
    cursor(self, "\033[s")
  end

  def restore_position
    cursor(self, "\033[u")
  end

  def cursor(text, position)
    "\r#{position}#{text}"
  end
end
