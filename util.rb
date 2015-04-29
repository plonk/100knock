# 7x番台

module Util
  # 正規分布にしたがった乱数の生成
  # http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
  TWO_PI = Math::PI * 2
  def generate_gaussian_noise(mu, sigma)
    $generate = !$generate
    if !$generate
      $z1 * sigma + mu
    else
      u1, u2 = loop.lazy.map { [rand, rand] }
        .drop_while { |u1, _| u1 <= Float::EPSILON }.first

      $z0 = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(TWO_PI * u2)
      $z1 = Math.sqrt(-2.0 * Math.log(u1)) * Math.sin(TWO_PI * u2)
      $z0 * sigma + mu
    end
  end
  module_function :generate_gaussian_noise

  def randn(n, *ns)
    if ns.empty?
      n.times.map { generate_gaussian_noise(0,1) }
    else
      n.times.map { randn(*ns) }
    end
  end
  module_function :randn

  # [-∞, +∞] → [0, 1]
  def sigmoid(z)
    1.0 / (1 + Math::E**-z)
  end
  module_function :sigmoid

  # 内積
  # def inner(a, b)
  #   a.zip(b).map { |ai,bi| ai*bi}.inject(:+)
  # end
  def inner(a, b)
    i = 0
    sum = 0
    ulimit = a.size
    while i < ulimit
      sum += a[i] * b[i]
      i += 1
    end
    sum
  end
  module_function :inner

end

