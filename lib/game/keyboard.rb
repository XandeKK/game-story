module Keyboard
  def self.read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def self.return_single_key
    c = self.read_char

    case c
    when " "
      :SPACE
    when "\t"
      :TAB
    when "\r"
      :RETURN
    when "\n"
      :LINE
    when "\e"
      :ESCAPE
    when "\e[A"
      :UP
    when "\e[B"
      :DOWN
    when "\e[C"
      :RIGHT
    when "\e[D"
      :LEFT
    when "\177"
      :BACKSPACE
    when "\004"
      :DELETE
    when "\e[3~"
      :ALTERNATE_DELETE
    when "\u0003"
      :CONTROL_C
    when /^.$/
      c.upcase.to_sym
    else
      c.upcase.to_sym
    end
  end
end