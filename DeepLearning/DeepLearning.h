#pragma once

#include <iostream>
#include <vector>
#include <omp.h>
#include <immintrin.h>

class Dim {
public:
    int Rows, Cols;
    Dim(int rows, int cols) : Rows(rows), Cols(cols) {}
    ~Dim() = default;
};

class Matrix {
public:
    Dim dims;
    std::vector<std::vector<double>> elements;

    // 构造函数
    Matrix(const std::vector<std::vector<double>>& array)
        : dims(array.size(), (array.size() > 0 ? array[0].size() : 0)),
        elements(array) {
        for (size_t i = 0; i < array.size(); ++i) {
            if (array[i].size() != dims.Cols) {
                std::cerr << "All rows must have the same number of columns!" << std::endl;
                exit(1);
            }
        }
    }

    // 默认构造函数
    Matrix() : dims(0, 0), elements() {}
    ~Matrix() = default;

    void Print() const {
        std::cout << "Rows_num: " << dims.Rows << ", Cols_num: " << dims.Cols << "\n";
        std::cout << "Size: " << dims.Rows << "*" << dims.Cols << "\n";
        std::cout << "[\n";
        for (const auto& row : elements) {
            std::cout << "  [ ";
            for (double val : row) {  
                std::cout << val << " ";
            }
            std::cout << "]\n";
        }
        std::cout << "]\n";
    }

    Matrix Transpose() const {
        // 创建转置矩阵的维度
        Dim new_dim(dims.Cols, dims.Rows);

        // 初始化转置矩阵的元素
        std::vector<std::vector<double>> transposed_elements(new_dim.Rows, std::vector<double>(new_dim.Cols));

        // 填充转置矩阵的元素
        #pragma omp parallel for collapse(2)
        for (int i = 0; i < dims.Rows; ++i) {
            for (int j = 0; j < dims.Cols; ++j) {
                transposed_elements[j][i] = elements[i][j];
            }
        }

        return Matrix(transposed_elements);
    }
};

Matrix Dot(const Matrix& x1, const Matrix& x2) {
    if (x1.dims.Cols != x2.dims.Rows) {
        std::cerr << "The columns of x1 must match the rows of x2." << std::endl;
        exit(1);
    }

    // 计算结果的矩阵大小
    Dim new_dim(x1.dims.Rows, x2.dims.Cols);

    // 初始化结果矩阵
    std::vector<std::vector<double>> result_elems(new_dim.Rows, std::vector<double>(new_dim.Cols));

    // 进行矩阵乘法
    #pragma omp parallel for collapse(2)
    for (int i = 0; i < new_dim.Rows; ++i) {
        for (int j = 0; j < new_dim.Cols; ++j) {
            double sum = 0.0;
            for (int k = 0; k < x1.dims.Cols; ++k) {
                sum += x1.elements[i][k] * x2.elements[k][j];
            }
            result_elems[i][j] = sum;
        }
    }

    return Matrix(result_elems);
}

Matrix Dot_AVX(const Matrix& x1, const Matrix& x2) {
    if (x1.dims.Cols != x2.dims.Rows) {
        std::cerr << "The columns of x1 must match the rows of x2." << std::endl;
        exit(1);
    }

    // 计算结果的矩阵大小
    Dim new_dim(x1.dims.Rows, x2.dims.Cols);

    // 初始化结果矩阵
    std::vector<std::vector<double>> result_elems(new_dim.Rows, std::vector<double>(new_dim.Cols, 0.0));

    // 确保内存对齐
    alignas(32) std::vector<double> temp_vec(4);  // 对应于一个AVX寄存器的宽度

    // 进行矩阵乘法
    for (int i = 0; i < new_dim.Rows; ++i) {
        for (int j = 0; j < new_dim.Cols; j += 4) {  // 每次处理4个元素
            __m256d sum = _mm256_setzero_pd();  // 初始化为零

            for (int k = 0; k < x1.dims.Cols; ++k) {
                // 加载x1和x2的数据到AVX寄存器
                __m256d vec_x1 = _mm256_set1_pd(x1.elements[i][k]);
                __m256d vec_x2;

                // 如果j+4超过了列数，则需要特殊处理
                if (j + 4 <= new_dim.Cols) {
                    vec_x2 = _mm256_loadu_pd(&x2.elements[k][j]);
                }
                else {
                    // 处理剩余的元素
                    for (int l = 0; l < 4; ++l) {
                        temp_vec[l] = (j + l < new_dim.Cols) ? x2.elements[k][j + l] : 0.0;
                    }
                    vec_x2 = _mm256_loadu_pd(temp_vec.data());
                }

                // 计算乘积并累加
                __m256d prod = _mm256_mul_pd(vec_x1, vec_x2);
                sum = _mm256_add_pd(sum, prod);
            }

            // 将结果存储回结果矩阵
            if (j + 4 <= new_dim.Cols) {
                _mm256_storeu_pd(&result_elems[i][j], sum);
            }
            else {
                // 存储剩余的元素
                double result_array[4];
                _mm256_storeu_pd(result_array, sum);
                for (int l = 0; l < 4; ++l) {
                    if (j + l < new_dim.Cols) {
                        result_elems[i][j + l] = result_array[l];
                    }
                }
            }
        }
    }

    return Matrix(result_elems);
}