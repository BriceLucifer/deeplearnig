const std = @import("std");
const Allocator = std.mem.Allocator;

pub const OpCode = enum(u8) {
    OP_RETURN,
};

pub const Chunk = struct {
    code: std.ArrayList(u8),
    count: i32,

    pub fn initChunk(self: *Chunk, allocator: Allocator) void {
        self.*.code = std.ArrayList(u8).init(allocator);
        self.*.count = 0;
    }

    pub fn writeChunk(self: *Chunk, byte: u8) !void {
        try self.code.append(byte);
        self.*.count += 1;
    }

    pub fn freeChunk(self: *Chunk) void {
        self.*.code.deinit();
    }
};
