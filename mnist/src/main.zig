const std = @import("std");
const math = @import("root.zig").math;

pub fn main() !void {
    const r = math.XOR(@Vector(2, f32){ 1, 0 });
    std.debug.print("XOR:(1,0) = {d}\n", .{r});

    const exp = math.Sigmoid(@Vector(2, f32){ 1.0, 2.0 });
    std.debug.print("Sigmoid:(1.0) = {d}\n", .{exp});

    const step = math.Step(@Vector(2, f32){ 1.0, -12.0 });
    std.debug.print("Step:(1,-12.0) = {d}\n", .{step});

    const relu = math.ReLU(@Vector(2, f32){ 7.8, -12.0 });
    std.debug.print("ReLU:(1,-12.0) = {d}\n", .{relu});

    const matrix_a = math.Matrix(f32, 3, 3).init([3][3]f32{
        [_]f32{ 1.0, 2.0, 3.0 },
        [_]f32{ 4.0, 5.0, 6.0 },
        [_]f32{ 7.0, 8.0, 9.0 },
    });

    const matrix_b = math.Matrix(f32, 3, 3).init([3][3]f32{
        [_]f32{ 9.0, 8.0, 7.0 },
        [_]f32{ 6.0, 5.0, 4.0 },
        [_]f32{ 3.0, 2.0, 1.0 },
    });

    const result = matrix_a.dot(matrix_b).?;
    result.print();
}
