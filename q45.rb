=begin

45. 動詞の格パターンの抽出

[...]

このプログラムの出力をファイルに保存し，以下の事項をUNIXコマンドを用いて確認せよ．

    A. コーパス中で頻出する述語と格パターンの組み合わせ
    B. 1.「する」2.「見る」3.「与える」という動詞の格パターン（コーパス中で出現頻度の高い順に並べよ）
---
	$ ruby q45.rb > q45.txt

した上で、

A.
    $ sort q45.txt | uniq -c  | sort -nr | head -10
        773 いる	て
        456 云う	と
        242 見る	て
        234 思う	と
        202 する	を
        164 なる	に
        156 する	と
        153 来る	て
        148 する	の
        145 ある	が

B.1.
    $ egrep '^する\s' q45.txt | sort | uniq -c | sort -nr
        202 する	を
        156 する	と
        148 する	の
        127 する	は
        120 する	に
        108 する	て
         79 する	が
         58 する	て を
         50 する	に を
         46 する	から
    [...]
    
B.2.    
    $ egrep '^見る\s' q45.txt | sort | uniq -c | sort -nr
        242 見る	て
         47 見る	を
         34 見る	の
         19 見る	は
         13 見る	と
         13 見る	で
         13 見る	から
         11 見る	て は
          9 見る	て の
          8 見る	に
     [...]

B.3.
     $ egrep '^与える\s' q45.txt | sort | uniq -c | sort -nr
          3 与える	を
          2 与える	に を
          1 与える	も を
          1 与える	に の
          1 与える	に に の
          1 与える	として に対する を
          1 与える	と に の は も より を を
          1 与える	て を
          1 与える	て も
          1 与える	て に を
     [...]

=end

require_relative 'q41'

def tabulate(list)
  list.each do |verb, particles|
    pstr = particles.map(&:base).join(' ')
    puts "#{verb.base}\t#{pstr}"
  end
end

def main
  load_document.each do |cs|
    verb_particle_pairs = pair_up(cs).flat_map { |c1, c2|
      particle = c1.morphs.find { |m| m.pos=='助詞' }
      verb = c2.morphs.find { |m| m.pos=='動詞' } # 最左の動詞を選択する

      # 1 文に同じ動詞が2回使われていた場合、パターンが混ざらないように
      # Morph 全体をキーにする
      particle && verb ? [ [verb, particle] ] : []
    }
    
    # 1文分を出力する
    tabulate to_multi_hash(verb_particle_pairs).value_map { |v| v.sort_by(&:base) } # uniq しないほうがいいかな？
  end

end

main
