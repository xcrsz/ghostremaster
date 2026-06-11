const std = @import("std");
const capture = @import("capture.zig");
const build = @import("build.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.next();

    const cmd = args.next() orelse {
        std.debug.print("Usage: ghostremaster capture|build\n", .{});
        return;
    };

    if (std.mem.eql(u8, cmd, "capture")) {
        try capture.run(allocator);
    } else if (std.mem.eql(u8, cmd, "build")) {
        try build.run(allocator);
    } else {
        std.debug.print("Unknown command\n", .{});
    }
}
