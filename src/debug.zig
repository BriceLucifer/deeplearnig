const std = @import("std");
const Chunk = @import("root.zig").chunk.Chunk;
const OpCode = @import("root.zig").chunk.OpCode;

fn simpleInstruction(name: []const u8, offset: i32) i32 {
    std.debug.print("{s}\n", .{name});
    return offset + 1;
}

pub fn disassembleInstruction(chunk: *Chunk, offset: i32) i32 {
    std.debug.print("{:0>4} ", .{offset});

    const instruction = chunk.code.items[@intCast(offset)];
    switch (instruction) {
        @intFromEnum(OpCode.OP_RETURN) => {
            return simpleInstruction("OP_RETURN", offset);
        },
        else => {
            std.debug.print("Unknown opcode {d}\n", .{instruction});
            return offset + 1;
        },
    }
}

pub fn disassembleChunk(chunk: *Chunk, name: []const u8) void {
    std.debug.print("== {s} ==\n", .{name});

    var offset: i32 = 0;
    while (offset < chunk.*.count) {
        offset = disassembleInstruction(chunk, offset);
    }
}
