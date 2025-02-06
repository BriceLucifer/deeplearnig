const std = @import("std");

// 定义一个矩阵结构体
pub fn Matrix(comptime T: type, comptime Rows: usize, comptime Cols: usize) type {
    return struct {
        Array: [Rows][Cols]T,

        // 构造函数
        pub fn init(values: [Rows][Cols]T) @This() {
            return @This(){ .Array = values };
        }

        // 矩阵乘法
        pub fn dot(self: *const @This(), other: @This()) ?@This() {
            const row_len_self = self.Array.len;
            const col_len_self = if (row_len_self > 0) self.Array[0].len else 0;

            const row_len_other = other.Array.len;
            const col_len_other = if (row_len_other > 0) other.Array[0].len else 0;

            if (col_len_self != row_len_other) {
                return null; // 不满足矩阵乘法规则
            }

            var result: [Rows][col_len_other]T = undefined;

            for (0..row_len_self) |i| {
                for (0..col_len_other) |j| {
                    result[i][j] = 0;
                    for (0..col_len_self) |k| {
                        result[i][j] += self.Array[i][k] * other.Array[k][j];
                    }
                }
            }

            return @This(){
                .Array = result,
            };
        }

        // 打印矩阵
        pub fn print(self: *const @This()) void {
            const GREEN_START = "\x1b[32m";
            const RESET = "\x1b[0m";

            std.debug.print(GREEN_START ++ "[\n", .{});
            for (self.Array) |row| {
                std.debug.print(GREEN_START ++ "\t[ ", .{});
                for (row) |value| {
                    std.debug.print("{d} ", .{value});
                }
                std.debug.print(GREEN_START ++ "\t]\n", .{});
            }
            std.debug.print(GREEN_START ++ "]" ++ RESET ++ "\n", .{});
        }
    };
}

// Gate Function;
fn GATE(x: @Vector(2, f32), w: @Vector(2, f32), b: f32) f32 {
    const temp = x * w;
    const result = @reduce(.Add, temp) + b;

    if (result <= 0) {
        return 0;
    } else {
        return 1;
    }
}

pub fn AND(x: @Vector(2, f32)) f32 {
    const w = @Vector(2, f32){ 0.5, 0.5 };
    return GATE(x, w, -0.7);
}

pub fn NAND(x: @Vector(2, f32)) f32 {
    const w = @Vector(2, f32){ -0.5, -0.5 };
    return GATE(x, w, 0.7);
}

pub fn OR(x: @Vector(2, f32)) f32 {
    const w = @Vector(2, f32){ 0.5, 0.5 };
    return GATE(x, w, -0.2);
}

pub fn XOR(x: @Vector(2, f32)) f32 {
    const s1 = NAND(x);
    const s2 = OR(x);
    return AND(@Vector(2, f32){ s1, s2 });
}

pub fn Sigmoid(x: @Vector(2, f32)) @Vector(2, f32) {
    const ones = @Vector(2, f32){ 1.0, 1.0 };
    return ones / (ones + std.math.exp(-x));
}

pub fn Step(x: @Vector(2, f32)) @Vector(2, bool) {
    const zeros = @Vector(2, f32){ 0.0, 0.0 };
    return x > zeros;
}

pub fn ReLU(x: @Vector(2, f32)) @Vector(2, f32) {
    const zeros = @Vector(2, f32){ 0.0, 0.0 };
    return @select(f32, x > zeros, x, zeros);
}
