const std = @import("std");

pub fn main() !void {
    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const path = try std.fs.realpath("input/input2.txt", &path_buffer);

    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const gpa = arena_allocator.allocator();

    const file = std.fs.cwd().openFile(path, .{}) catch |e| {
        std.log.err("Failed to open file: {s}.", .{@errorName(e)});
        return;
    };
    defer file.close();

    const contents = try file.reader().readAllAlloc(gpa, std.math.maxInt(usize));

    const safe_report_1 = try firstPart(gpa, contents);
    try std.io.getStdOut().writer().print("1st part, total is {}\n", .{safe_report_1});

    const safe_report_2 = try secondPart(gpa, contents);
    try std.io.getStdOut().writer().print("2nd part, total is {}\n", .{safe_report_2});
}

pub fn secondPart(gpa: std.mem.Allocator, contents: []u8) !u32 {
    var safe_report: u32 = 0;

    var lines = std.mem.tokenizeAny(u8, contents, "\n");

    while (lines.next()) |line| {
        var list = std.ArrayList(u32).init(gpa);
        var it = std.mem.tokenizeAny(u8, line, " ");
        while (it.next()) |num| {
            const n = try std.fmt.parseInt(u32, num, 10);
            try list.append(n);
        }

        var ok = false;
        const slice = try list.toOwnedSlice();

        for (0..slice.len) |i| {
            if (isok(slice, i)) {
                ok = true;
            }
        }
        if (ok) {
            safe_report += 1;
        }
    }
    return safe_report;
}

pub fn isok(list: []const u32, skip: usize) bool {
    var negdiff = false;
    var posdiff = false;
    var baddiff = false;

    var i: usize = if (skip == 0) 2 else 1;
    while (i < list.len) : (i += 1) {
        if (i == skip) continue;

        const this = @as(i64, list[i]);
        const prev = @as(i64, list[if (i - 1 == skip) i - 2 else i - 1]);
        const diff = this - prev;

        if (diff < 0) negdiff = true;
        if (diff > 0) posdiff = true;
        if (diff < -3 or diff == 0 or diff > 3) baddiff = true;
    }

    return (!posdiff or !negdiff) and !baddiff;
}

pub fn firstPart(gpa: std.mem.Allocator, contents: []u8) !u32 {
    var safe_report: u32 = 0;

    var lines = std.mem.tokenizeAny(u8, contents, "\n");

    line_while: while (lines.next()) |line| {
        var list = std.ArrayList(u32).init(gpa);
        var it = std.mem.tokenizeAny(u8, line, " ");
        while (it.next()) |num| {
            const n = try std.fmt.parseInt(u32, num, 10);
            try list.append(n);
        }
        const slice_sorted = try list.toOwnedSlice();
        if (std.sort.isSorted(u32, slice_sorted, {}, std.sort.desc(u32))) {
            std.mem.sort(u32, slice_sorted, {}, std.sort.asc(u32));
        }
        if (std.sort.isSorted(u32, slice_sorted, {}, std.sort.asc(u32))) {
            for (0..(slice_sorted.len - 1)) |i| {
                if (((slice_sorted[i + 1] - slice_sorted[i]) > 3) or ((slice_sorted[i + 1] - slice_sorted[i]) < 1)) {
                    continue :line_while;
                }
            }
            safe_report += 1;
        }
    }
    return safe_report;
}
