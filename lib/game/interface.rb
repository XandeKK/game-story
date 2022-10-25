class Interface
  def initialize(main)
    @name = "main.json"
    @main = main
    @text = @main["body_text"]
    @choices = @main["choices"]
    @position = 0
    @stack = []
    @stack.push(@main)
    system "clear"
  end

  def winsize
    begin
      IO.console.winsize
    rescue LoadError
      [Integer(`tput li`), Integer(`tput co`)]
    end
  end

  def break_text(text, width)
    text_split = text.split(" ")
    words = []
    words_tmp = ""
    size = 0

    text_split.each do |word|
      size += word.length
      if size >= width - (width/5)
        words.append(words_tmp.rjust(words_tmp.length + 5))
        words_tmp = ""
        size = word.length
        words_tmp << "#{word} "
      else
        words_tmp << "#{word} "
      end
    end
    words.append(words_tmp.rjust(words_tmp.length + 5)) unless words_tmp.empty?
    words
  end

  def break_line(number=1)
    puts "\n"*number
  end

  def to_go(file)
    @name = file
    @main =  FileHandling.json_to_hash("test/#{file}")
    @text = @main["body_text"]
    @choices = @main["choices"]
    @stack.push(@main)
  end

  def to_back
    if @stack.length > 1
      @stack.pop
      @main = @stack.last
      @text = @main["body_text"]
      @choices = @main["choices"]
    end
  end

  def action
    key = Keyboard.return_single_key
    case key
    when :CONTROL_C
      @position = 0
      to_go("exit.json")
    when :UP
      @position += -1
      @position = @position % @choices.length
    when :DOWN
      @position += 1
      @position = @position % @choices.length
    when :B
      to_back
    when :SPACE
      if @choices.empty?
        ERB.new(@main["to_go"]).result(binding)
      else
        ERB.new(@choices[@position]["to_go"]).result(binding)
      end
      @position = 0
    end
  end

  def write_hotkeys
    puts "\e[7mb - back\e[27m"
  end

  def write_body
    puts break_text(@main["body_text"], @size[1])
  end

  def write_choices
    if @choices.empty?
      puts "->".rjust(@size[1] - 2)
    else
      break_line
      puts "="*@size[1]
      break_line
      @choices.each_with_index do |choice, index|
        puts ("-"*(@size[1] - 2)).center(@size[1])
        print "\e[7m"  if index == @position
        puts break_text(choice["text"], @size[1]).map { |e| e.center(@size[1]) } 
        print "\e[27m"
      end
      puts ("-"*(@size[1] - 2)).center(@size[1])
      break_line
      puts "="*@size[1]
    end
  end

  def start
    loop do
      @size = winsize
      p @name
      write_hotkeys
      break_line(3)
      write_body
      write_choices
      action
      system "clear"
    end
  end
end