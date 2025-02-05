const std = @import("std");
const value = @import("value.zig");

const ValueArray = value.ValueArray;
const Allocator = std.mem.Allocator;

pub const OpCode = enum(u8) {
    OP_CONSTANT,
    OP_RETURN,
    OP_UNKNOWN,

    pub fn toString(self: OpCode) []const u8 {
        switch (self) {
            OpCode.OP_CONSTANT => return "OP_CONSTANT",
            OpCode.OP_RETURN => return "OP_RETURN",
            else => return "OP_UNKNOWN",
        }
    }
};

pub const Chunk = struct {
    code: std.ArrayList(OpCode),
    count: i32,
    constants: ValueArray,

    pub fn initChunk(self: *Chunk, allocator: Allocator) void {
        self.*.code = std.ArrayList(OpCode).init(allocator);
        self.*.count = 0;
        ValueArray.initValueArray(&self.*.constants, allocator);
    }

    pub fn writeChunk(self: *Chunk, byte: OpCode) !void {
        try self.code.append(byte);
        self.*.count += 1;
    }

    pub fn addConstant(self: *Chunk, constant: f64) i32 {
        try ValueArray.writeValueArray(&self.*.constants, constant);
        return self.*.constants.count - 1;
    }

    pub fn freeChunk(self: *Chunk) void {
        self.*.code.deinit();
    }
};
