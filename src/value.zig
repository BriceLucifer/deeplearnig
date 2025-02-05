const std = @import("std");
pub const Value = f64;

pub const ValueArray = struct {
    count: i32,
    values: std.ArrayList(Value),

    pub fn initValueArray(self: *ValueArray, allocator: std.mem.Allocator) void {
        self.*.count = 0;
        self.*.values = std.ArrayList(Value).init(allocator);
    }

    pub fn writeValueArray(self: *ValueArray, value: Value) !void {
        try self.*.values.append(value);
        self.*.count += 1;
    }

    pub fn freeValueArray(self: *ValueArray) void {
        self.*.values.deinit();
    }
};
