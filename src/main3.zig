const std = @import("std");

pub fn main() !void {

    var path_buffer : [std.fs.max_path_bytes]u8 = undefined;
    const path = try std.fs.realpath("input/input3.txt", &path_buffer);

    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const gpa = arena_allocator.allocator();

    const file = std.fs.cwd().openFile(path, .{}) catch |e| {
        std.log.err("Failed to open file: {s}", .{@errorName(e)});
        return;
    };
    defer file.close();

    const contents = try file.reader().readAllAlloc(gpa, std.math.maxInt(usize));

    const result_1 = try firstPart(contents);
    try std.io.getStdOut().writer().print("1st part, total is: {}\n", .{result_1});

    const result_2 = try secondPart(contents);
    try std.io.getStdOut().writer().print("2nd part, total is: {}\n", .{result_2});

}

pub fn firstPart(contents: []u8) !u32 {

    var sum_mult : u32 = 0;

    var i: usize = 0;

    while (i <= (contents.len-4)) {
        sum_mult += parseMul(contents, &i) orelse continue;
    }
    return sum_mult;
}

pub fn secondPart(contents: []u8) !u32 {
    var sum_mult : u32 = 0;
    const do_patern = "do()";
    const dont_patern = "don't()";

    var i: usize = 0;

    var do: bool = true;

    while (i <= (contents.len-4)) {
        if (do) {
            if ((i <= contents.len-7) and std.mem.eql(u8, contents[i..i+7], dont_patern)) {
                do = false;
            } else {
                sum_mult += parseMul(contents, &i) orelse continue;
            }
        } else {
            if (std.mem.eql(u8, contents[i..i+4], do_patern)) {
                do = true;
            }
            i += 1;
        }
    }
    return sum_mult;
}


pub fn parseMul(contents: []u8, index: *usize) ?u32 {

    const mul_pattern = "mul(";
    const rpar = ')';
    const coma = ',';

    if (std.mem.eql(u8, contents[index.*..index.*+4], mul_pattern)) {
        index.* += 4;
        const num_1 = parseNum(contents, index) orelse return null;

        if (index.* >= contents.len or contents[index.*] != coma) {
            return null;
        }
        index.* += 1;
        const num_2 = parseNum(contents, index) orelse return null;

        if (index.* >= contents.len or contents[index.*] != rpar) {
            return null;
        }
        index.* += 1;

        return num_1 * num_2;
    } else {
        index.* += 1;
        return null;
    }

}


pub fn parseNum(contents: []u8, index: *usize) ?u32 {

    const start = index.*;

    while ((index.* < contents.len) and (std.ascii.isDigit(contents[index.*]))) {
        index.* += 1;
    }
    if (index.* == start) {
        return null;
    } else {
        return std.fmt.parseInt(u32, contents[start..index.*], 10) catch |e| {
            std.log.err("Failed to parse {s} to Int: {s}", .{contents[start..index.*], @errorName(e)});
            return null;
        };
    }

}
