#include <cmath>
#include <string>
#include <limits>
#include <cstdio>
#include <vector>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <cassert>

// ロジスティック回帰
// http://gihyo.jp/dev/serial/01/machine-learning/0020

#define INSPECT(v) { cout << "["; for (auto i = v.begin(); i != v.end(); i++) { cout << *i << ", "; } cout << "\b\b]" << endl; }

namespace Util
{
    using namespace std;

    static constexpr double TWO_PI =  M_PI * 2;


    // 正規分布にしたがった乱数の生成
    // http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

    static bool generate = false;
    static double z0, z1;
    double generate_gaussian_noise(double mu, double sigma)
    {
        generate = !generate;
        if (!generate) {
            return z1 * sigma + mu;
        } else {
            double u1, u2;
            do {
                u1 = (double)rand() / RAND_MAX;
                u2 = (double)rand() / RAND_MAX;
            } while (u1 <= numeric_limits<double>::epsilon());

            z0 = sqrt(-2.0 * log(u1)) * cos(TWO_PI * u2);
            z1 = sqrt(-2.0 * log(u1)) * sin(TWO_PI * u2);
            return z0 * sigma + mu;
        }
    }
            
// これ C++ でかくのむり。

    vector<double> rand1(size_t n)
    {
        vector<double> ret;

        for (size_t i = 0; i < n; i++)
            ret.push_back(generate_gaussian_noise(0,1));

        return ret;
    }

    double sigmoid(double x)
    {
        return 1.0 / (1 + exp(-x));
    }

    template <typename T, typename U> T inner(const vector<T>& a, const vector<U>& b)
    {
        double sum = 0;

        for (size_t i = 0; i < a.size(); i++)
            sum += a[i] * b[i];

        return sum;
    }
}

using namespace Util;

extern int stem(char * p, int i, int j);

class Program
{
    // 特徴空間に写像する何か
    template <typename T>
    vector<double> phi(const vector<T>& xs) {
        vector<double> ys(xs.begin(), xs.end());
        ys.push_back(1);
        return ys;
    }

    vector<string> words;
    void load_feature_definition() {
        words.clear();
        ifstream f("features.txt");
        string feat;
        while (getline(f, feat)) {
            words.push_back(feat);
        }
    }

    static string stem(const string& word) {
        int end = ::stem(const_cast<char *>(word.c_str()), 0, word.size() - 1);
        return word.substr(0, end + 1);
    }

    // String → [0 or 1, ...]
    // 返り値の size は @words.size に等しい。

    vector<string> split(const string& s) {
        vector<string> ret;
        string buf;

        for (char c : s) {
            if (isspace(c)) {
                if (buf!="") {
                    ret.push_back(buf);
                    buf.clear();
                }
            } else {
                buf.push_back(c);
            }
        }
        if (buf!="") {
            ret.push_back(buf);
            buf.clear();
        }
        return ret;
    }

    vector<bool> to_features(const string& s) {
        vector<string> stems;
        vector<string> ws = split(s);
        transform(ws.begin(), ws.end(), back_inserter(stems), [] (string t) { return stem(t); });
        sort(stems.begin(), stems.end());
        auto end = unique(stems.begin(), stems.end());

        vector<bool> ret;
        transform(words.begin(), words.end(), back_inserter(ret),
                  [&stems, end] (string t) { return find(stems.begin(), end, t) != end; });
        return ret;
    }

    vector<double> polarities;
    vector<string> sentences;
    vector<vector<bool> > feature_bundles;
    size_t nsentences;

    void load_data() {
        ifstream f("sentiment.txt");
        string line;

        while (getline(f, line)) {
            polarities.push_back( line[0] == '+' ? 1.0 : 0.0 );
            string s = line.substr(3);
            sentences.push_back(s);
            feature_bundles.push_back(to_features(s));
        }
        nsentences = sentences.size();
    }

    template <typename T>
    vector<T> range(T start, T end) {
        vector<T> ret;
        for (T i = start; i < end; i++) {
            ret.push_back(i);
        }
        return ret;
    }

    void print_result(vector<double> w) {
        for (size_t i = 0; i < feature_bundles.size(); i++) {
            auto v = feature_bundles[i];
            double probability = sigmoid(inner(w,phi(v)));
            printf("%.2f\t%.2f\t%s\n", polarities[i], probability, sentences[i].c_str());
        }
    }

public:
    void main() {
        load_feature_definition();
        cerr << "stems loaded\n";
        load_data();
        cerr << "data loaded\n";

        srand(time(NULL));
        vector<double> weights = rand1(words.size() + 1);
        double eta = 0.1; // 学習率

        for (size_t i = 0; i < 50; i++) {
            cerr << "iteration " << i+1;

            auto list = range<size_t>(0, nsentences);
            random_shuffle(list.begin(), list.end());

            for (size_t n : list) {
                vector<double> features = phi(feature_bundles[n]);
                double prediction = sigmoid(inner(weights, features));

                for (size_t j = 0; j < weights.size(); j++) {
                    weights[j] = weights[j] - eta * (prediction - polarities[n]) * features[j];
                }
            }
            eta *= 0.9;

            cerr << endl;
        }

        print_result(weights);
    }
};

int main(int argc, char* argv[]) {
    Program().main();
}
