const std = @import("std");

pub const Profile = struct {
    version: u32,
    packages: []const []const u8,
};
