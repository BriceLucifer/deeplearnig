const std = @import("std");
const GROW_CAPACITY = @import("memory.zig").GROW_CAPACITY;

pub const OpCode = enum(u8) {
    OP_RETURN,
};

pub const Chunk = struct {
    count: i32,
    capacity: i32,
    code: [*]u8,

    pub fn initChunk(self: *Chunk) void {
        self.*.count = 0;
        self.*.capacity = 0;
        self.*.code = null;
    }

    pub fn writeChunk(self: *Chunk, byte: u8) void {
        if (self.capacity < self.count + 1) {
            const oldCapacity = self.*.capacity;
            self.capacity = GROW_CAPACITY(oldCapacity);
            // self.code = GROW_ARRAY();
        }

        self.*.code[self.*.count] = byte;
        self.*.count += 1;
    }
};
