const std = @import("std");

pub fn hashFile(path: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var hasher = std.crypto.hash.sha2.Sha256.init(.{});
    var buf: [4096]u8 = undefined;

    while (true) {
        const n = try file.read(&buf);
        if (n == 0) break;
        hasher.update(buf[0..n]);
    }

    var out: [32]u8 = undefined;
    hasher.final(&out);

    return try std.fmt.allocPrint(
        allocator,
        "{x}",
        .{out},
    );
}
