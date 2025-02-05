const std = @import("std");
const root = @import("root.zig");
const debug = root.debug;

const Chunk = root.chunk.Chunk;
const OpCode = root.chunk.OpCode;
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var chunk: Chunk = undefined;
    Chunk.initChunk(&chunk, gpa.allocator());
    try chunk.writeChunk(@intFromEnum(OpCode.OP_RETURN));
    debug.disassembleChunk(&chunk, "test chunk");
    defer chunk.freeChunk();
}
