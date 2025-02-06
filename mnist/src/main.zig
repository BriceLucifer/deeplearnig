const std = @import("std");
const math = @import("root.zig").math;

pub fn main() !void {
    const r = math.XOR(@Vector(2, f32){ 1, 0 });
    std.debug.print("XOR:\n\t{d} = {d}\n", .{ @Vector(2, f32){ 1, 0 }, r });

    const exp = math.Sigmoid(3, @Vector(3, f32){ 1.0, 2.0, 3.0 });
    std.debug.print("Sigmoid:\n\t{d} = {d}\n", .{ @Vector(3, f32){ 1.0, 2.0, 3.0 }, exp });

    const step = math.Step(4, @Vector(4, f32){ 1.0, -12.0, 4.0, 0.0 });
    std.debug.print("Step:\n\t{d} = {d}\n", .{ @Vector(4, f32){ 1.0, -12.0, 4.0, 0.0 }, step });

    const relu = math.ReLU(3, @Vector(3, f32){ 7.8, -12.0, 9.9 });
    std.debug.print("ReLU:\n\t{d} = {d}\n", .{ @Vector(3, f32){ 7.8, -12.0, 9.9 }, relu });

    const matrix_a = math.Matrix(f32, 3, 3).init([3][3]f32{
        [_]f32{ 1.0, 2.0, 3.0 },
        [_]f32{ 4.0, 5.0, 6.0 },
        [_]f32{ 7.0, 8.0, 9.0 },
    });
    matrix_a.print();

    const matrix_b = math.Matrix(f32, 3, 3).init([3][3]f32{
        [_]f32{ 9.0, 8.0, 7.0 },
        [_]f32{ 6.0, 5.0, 4.0 },
        [_]f32{ 3.0, 2.0, 1.0 },
    });

    var result = matrix_a.dot(matrix_b).?;
    std.debug.print("matrix_a dot matrix_b(no_SIMD): ", .{});
    result.print();

    result = matrix_a.dot_SIMD(matrix_b).?;
    std.debug.print("matrix_a dot matrix_b(SIMD): ", .{});
    result.print();

    const vec_rows = matrix_a.Vector_Row();
    for (vec_rows) |value| {
        std.debug.print("date:{d}\ttype:{s}\n", .{ value, @typeName(@TypeOf(value)) });
    }

    std.debug.print("==========\n", .{});

    const vec_cols = matrix_b.Vector_Col();
    const len = matrix_b.Array[0].len;
    for (vec_cols) |col| {
        std.debug.print("date:{d}\ttype:{s}\t", .{ col, @typeName(@TypeOf(col)) });
        std.debug.print("Sigmoid:{d}\t\n", .{math.Sigmoid(len, col)});
    }
}
