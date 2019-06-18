require 'io/console'

COLS, ROWS = 15, 10
UP, DOWN, LEFT, RIGHT = -COLS, COLS, -1, 1

field = Array.new(SIZE = COLS * ROWS, '.')

tail = [head = COLS * (ROWS + 1) / 2]

field[head] = '*'

(place_goat = -> { field[field.zip((0..)).select { |v, _| v == '.' }.sample[1]] = '+' }).()

move, score = UP, 0

Thread.new do
  loop do
    key = STDIN.getch
    move = key == 'q' && exit ||
        key == 'w' && UP ||
        key == 's' && DOWN ||
        key == 'a' && LEFT ||
        key == 'd' && RIGHT ||
        move
  end
end

print "\e[2J\e[?25l"

begin
  loop do
    head += move

    head += SIZE if move == UP && head < 0
    head -= SIZE if move == DOWN && head >= SIZE
    head -= COLS if move == RIGHT && head % COLS == 0
    head += COLS if move == LEFT && head % COLS == COLS - 1

    field[head] == '*' && break

    if field[head] != '+'
      field[tail[0]] = '.'
      tail = tail.drop(1)
    else
      score += 1
      place_goat.()
    end

    tail << head

    field[head] = '*'

    print "\e[H"
    field.each_slice(COLS) { |c| puts "#{c.join}\e[#{COLS}D" }
    puts "+#{score}\e[#{COLS}D"

    sleep(0.2)
  end
ensure
  print "\e[?25h"
end
