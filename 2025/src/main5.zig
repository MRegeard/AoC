const std = @import("std");
const stdout = std.io.getStdOut().writer();
const mem = std.mem;
const assert = std.debug.assert;

pub fn main() !void {
    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const path = std.fs.realpath("input/input5_test.txt", &path_buffer) catch |e| {
        std.log.err("File not found: {s}", .{@errorName(e)});
        return e;
    };

    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const gpa = arena_allocator.allocator();

    const file = std.fs.cwd().openFile(path, .{}) catch |e| {
        std.log.err("Fail to open file: {s}", .{@errorName(e)});
        return e;
    };
    defer file.close();

    const contents = try file.readToEndAlloc(gpa, std.math.maxInt(usize));

    var it = mem.tokenizeSequence(u8, contents, "\n\n");
    var ordering = try gpa.alloc(u8, it.peek().?.len);
    for (it.next().?, 0..) |char, i| {
        ordering[i] = char;
    }

    var produce = try gpa.alloc(u8, it.peek().?.len);
    for (it.next().?, 0..) |char, i| {
        produce[i] = char;
    }

    assert(it.next() == null);

    const first_res = try firstPart(gpa, produce, ordering);

    try stdout.print("First part, total is {}\n", .{first_res});

    const second_res = try secondPart(gpa, produce, ordering);

    try stdout.print("Second part, total is {}\n", .{second_res});
}


pub fn secondPart(gpa: mem.Allocator, produce: []u8, ordering: []u8) !u32 {

    var counts: u32 = 0;
    var it = mem.tokenizeAny(u8, produce, "\n");

    while (it.peek()) |line| {
        const it_split_coma = mem.tokenizeAny(u8, line, ",");
        const mutable_it_split_coma = @as(mem.TokenIterator(u8, .any), it_split_coma);
        const line_pages = try collect(gpa, mutable_it_split_coma);
        reverseArray(line_pages);
        try stdout.print("{any}\n", .{line_pages});
        var has_been_corrected: bool = false;
        for (line_pages, 0..line_pages.len) |page, i| {
            var it_order_line = mem.tokenizeAny(u8, ordering, "\n");
            while (it_order_line.next()) |order_line| {
                var it_page = mem.tokenizeAny(u8, order_line, "|");
                const before = try std.fmt.parseInt(u32, it_page.next().?, 10);
                const after = try std.fmt.parseInt(u32, it_page.next().?, 10);
                if (before == page) {
                    var j = i;
                    while (isIn(line_pages[i..], after) and (j<line_pages.len-1)) {
                        try stdout.print("Line Page before swap: {any}\n", .{line_pages});
                        has_been_corrected = true;
                        const tmp = line_pages[j];
                        line_pages[j] = line_pages[j+1];
                        line_pages[j+1] = tmp;
                        try stdout.print("Line page after swap: {any}\n", .{line_pages});
                        j += 1;
                    }
                }

            }
        }
        if (has_been_corrected) {
            const to_add = line_pages[line_pages.len/2];
            try stdout.print("{}\n", .{to_add});
            counts += to_add;
        }

    }
    return counts;
}


pub fn firstPart(gpa: mem.Allocator, produce: []u8, ordering: []u8) !u32 {
    var counts: u32 = 0;
    var it = mem.tokenizeAny(u8, produce, "\n");

    main_loop: while (it.next()) |line| {
        const it_split_coma = mem.tokenizeAny(u8, line, ",");
        const mutable_it_split_coma = @as(mem.TokenIterator(u8, .any), it_split_coma);
        const line_pages = try collect(gpa, mutable_it_split_coma);
        reverseArray(line_pages);
        for (line_pages, 0..line_pages.len) |page, i| {
            var it_order_line = mem.tokenizeAny(u8, ordering, "\n");
            while (it_order_line.next()) |order_line| {
                var it_page = mem.tokenizeAny(u8, order_line, "|");
                const before = try std.fmt.parseInt(u32, it_page.next().?, 10);
                const after = try std.fmt.parseInt(u32, it_page.next().?, 10);
                if (before == page) {
                    if (isIn(line_pages[i..], after)) {
                        continue :main_loop;
                    }
                }

            }
        }

        const to_add = line_pages[line_pages.len/2];
        counts += to_add;

    }
    return counts;
}



pub fn isIn(array: []u32, value: u32) bool {
    for (array) |elem| {
        if (elem == value) {
            return true;
        }
    }
    return false;
}


pub fn collect(gpa: mem.Allocator, iterator: mem.TokenIterator(u8, .any)) ![]u32 {
    var collector = std.ArrayList(u32).init(gpa);
    var mut_it = @as(mem.TokenIterator(u8, .any), iterator);
    while (mut_it.next()) |token| {
        const num = try std.fmt.parseInt(u32, token, 10);
        try collector.append(num);
    }
    const owned_collector = try collector.toOwnedSlice();
    return owned_collector;
}


pub fn reverseArray(array: []u32) void {
    const lenght = array.len;
    for (0..lenght / 2) |i| {
        const j = lenght - 1 - i;
        const tmp = array[i];
        array[i] = array[j];
        array[j] = tmp;
    }
}
