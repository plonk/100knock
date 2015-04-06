=begin

16. ファイルをN分割する

自然数Nをコマンドライン引数などの手段で受け取り，入力のファイルを行単位
でN分割せよ．同様の処理をsplitコマンドで実現せよ．

※ split -n l/N の挙動を真似る。

=end

require 'colorize'

def usage(message)
  puts "Usage: #{$0} -[N] [FILE]"
  puts
  puts "[FILE] を行を単位に [N] 分割する。出力ファイル名は xaa ~ xzz。"
  puts
  puts "#{message}".bold.red
end

class UsageError < StandardError
end

def split_file(stream, filesize, n)
  outfiles = ('aa'..'zz').take(n).map { |sfx| File.new("x#{sfx}", 'w')}
  size_per_file = filesize / n
  written = 0
  lines = stream.each_line.to_a
  nth_file = 1

  current_file = outfiles.shift
  current_line = lines.shift

  current_file.write current_line
  written += current_line.bytesize
  current_line = lines.shift

  while current_line
    # オーバーしていたら今のファイルを閉じて次のファイルに移動する。
    # オーバーした分が取り戻せるまでスキップすることもある。
    # ただし、もう最後のファイルに来ている場合は気にせず書き込む。
    if nth_file * size_per_file < written && nth_file != n
      current_file.close
      current_file = outfiles.shift
      nth_file += 1
    else
      current_file.write current_line
      written += current_line.bytesize
      current_line = lines.shift
    end
  end

  # 書き込まれなかった残りのファイルを閉じる
  outfiles.each(&:close)
end

def main
  opt = ARGV.find { |arg| arg.start_with?('-') }
  raise UsageError, 'Number unspecified' unless opt
  ARGV.delete_if { |opt| opt.start_with?('-') }
  n = -(opt.to_i)
  raise UsageError, 'Exactly one file must be specified' unless ARGV.size == 1
  filename = ARGV[0]

  File.open(filename) do |f|
    split_file(f, File.stat(filename).size, n)
  end
rescue UsageError => e
  usage(e.message)
  exit 1
end

main
