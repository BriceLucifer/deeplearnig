#include "DeepLearning.h"
#include <chrono>
#include <random>

// 生成随机矩阵数据
std::vector<std::vector<double>> generate_random_matrix(int rows, int cols, double min_val = -1.0, double max_val = 1.0) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(min_val, max_val);

    std::vector<std::vector<double>> matrix(rows, std::vector<double>(cols));
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            matrix[i][j] = dis(gen);
        }
    }
    return matrix;
}

int main() {
    // 设置较大的矩阵尺寸
    const int rows_m1 = 4000;
    const int cols_m1 = 900;
    const int rows_m2 = cols_m1; // 确保矩阵可以相乘
    const int cols_m2 = 600;

    // 生成随机矩阵数据
    std::vector<std::vector<double>> data1 = generate_random_matrix(rows_m1, cols_m1);
    std::vector<std::vector<double>> data2 = generate_random_matrix(rows_m2, cols_m2);

    Matrix m1(data1);
    Matrix m2(data2);

    // 普通矩阵乘法
    auto start = std::chrono::high_resolution_clock::now();
    auto r = Dot(m1, m2);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end - start;
    std::cout << "Standard Dot Product Time: " << elapsed.count() << " seconds\n";

    // 输出结果矩阵的一部分（因为太大了，全部输出不现实）
    std::cout << "Result Matrix (first 5x5 elements):\n";
    for (int i = 0; i < 5 && i < r.dims.Rows; ++i) {
        for (int j = 0; j < 5 && j < r.dims.Cols; ++j) {
            std::cout << r.elements[i][j] << " ";
        }
        std::cout << "\n";
    }

    // AVX 加速的矩阵乘法
    start = std::chrono::high_resolution_clock::now();
    auto r_avx = Dot_AVX(m1, m2);
    end = std::chrono::high_resolution_clock::now();
    elapsed = end - start;
    std::cout << "AVX Dot Product Time: " << elapsed.count() << " seconds\n";

    // 输出结果矩阵的一部分（因为太大了，全部输出不现实）
    std::cout << "AVX Result Matrix (first 5x5 elements):\n";
    for (int i = 0; i < 5 && i < r_avx.dims.Rows; ++i) {
        for (int j = 0; j < 5 && j < r_avx.dims.Cols; ++j) {
            std::cout << r_avx.elements[i][j] << " ";
        }
        std::cout << "\n";
    }

    // 转置矩阵
    std::cout << "Transposed Matrix (first 5x5 elements):\n";
    Matrix transposed_m = r_avx.Transpose();
    for (int i = 0; i < 5 && i < transposed_m.dims.Rows; ++i) {
        for (int j = 0; j < 5 && j < transposed_m.dims.Cols; ++j) {
            std::cout << transposed_m.elements[i][j] << " ";
        }
        std::cout << "\n";
    }

    return 0;
}