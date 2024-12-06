const std = @import("std");
const mem = @import("std").mem;
const stdout = @import("std").io.getStdOut();

const Direction = enum {
    East,
    West,
    North,
    South,
    NorthEast,
    NorthWest,
    SouthEast,
    SouthWest,
};

pub fn isvalidDir(dir: Direction, table: [][]const u8, i: usize, j: usize) bool {
    const len_row = table[0].len;
    const len_cols = table.len;
    switch (dir) {
        .East => return j <= len_row - 4,
        .West => return j >= 3,
        .North => return i >= 3,
        .South => return i <= len_cols - 4,
        .NorthEast => return (isvalidDir(Direction.East, table, i, j) and isvalidDir(Direction.North, table, i, j)),
        .NorthWest => return (isvalidDir(Direction.West, table, i, j) and isvalidDir(Direction.North, table, i, j)),
        .SouthEast => return (isvalidDir(Direction.East, table, i, j) and isvalidDir(Direction.South, table, i, j)),
        .SouthWest => return (isvalidDir(Direction.West, table, i, j) and isvalidDir(Direction.South, table, i, j)),
    }
}

pub fn isValidPos(table: [][]const u8, i: usize, j: usize) bool {
    return (!((i == 0) or (j == 0) or (i == (table.len - 1)) or (j == (table[0].len - 1))) and (table[i][j] == 'A'));
}

pub fn main() !void {
    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const path = try std.fs.realpath("input/input4.txt", &path_buffer);

    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const gpa = arena_allocator.allocator();

    const file = std.fs.cwd().openFile(path, .{}) catch |e| {
        std.log.err("Failed to open file: {s}", .{@errorName(e)});
        return;
    };
    defer file.close();

    const contents = try file.reader().readAllAlloc(gpa, std.math.maxInt(usize));

    var it = mem.tokenizeAny(u8, contents, "\n");
    const len_line = it.peek().?.len;

    const number_line = contents.len / (len_line + 1);

    const table = try gpa.alloc([]const u8, number_line);

    var l: usize = 0;
    while (it.next()) |line| {
        table[l] = line;
        l += 1;
    }

    const type_info = @typeInfo(Direction);
    const enum_fields = type_info.Enum.fields;

    var counts: u32 = 0;
    var counts2: u32 = 0;
    for (0..table.len) |row_idx| {
        for (0..table[0].len) |col_idx| {
            inline for (enum_fields) |field| {
                const dir = @field(Direction, field.name);
                const is_valid_dir = isvalidDir(dir, table, row_idx, col_idx);
                if (is_valid_dir) {
                    counts += parseXmas(dir, table, row_idx, col_idx);
                }
            }
            const is_valid_pos = isValidPos(table, row_idx, col_idx);
            std.log.info("{} {}: {}\n", .{ row_idx, col_idx, is_valid_pos });
            if (is_valid_pos) {
                counts2 += parseCrossMas(table, row_idx, col_idx);
            }
        }
    }
    try stdout.writer().print("1st part, total is: {}\n", .{counts});
    try stdout.writer().print("2nd part, total is: {}\n", .{counts2});
}

pub fn parseCrossMas(table: [][]const u8, i: usize, j: usize) u32 {
    const pattern = "MAS";

    var coord_add_i: i8 = 1;
    var coord_add_j: i8 = 1;

    const ii: i16 = @intCast(i);
    const jj: i16 = @intCast(j);

    var compare1: [3]u8 = undefined;
    var quarter_turn: u8 = 0;
    while (quarter_turn < 4) {
        for (0..3) |k| {
            const kk: i8 = @intCast((k));
            const row_idx: i16 = ii + (kk - 1) * coord_add_i;
            const col_idx: i16 = jj + (kk - 1) * coord_add_j;
            const row_id: usize = @intCast(row_idx);
            const col_id: usize = @intCast(col_idx);
            std.log.info("{} {}", .{ row_id, col_id });
            std.log.info("{}", .{table[row_id][col_id]});
            compare1[k] = table[row_id][col_id];
        }
        std.log.info("Compare is {s}", .{compare1});
        if (mem.eql(u8, pattern, &compare1)) {
            rotate(&coord_add_i, &coord_add_j);
            quarter_turn += 1;
            for (0..3) |k| {
                const kk: i8 = @intCast((k));
                const row_idx: i16 = ii + (kk - 1) * coord_add_i;
                const col_idx: i16 = jj + (kk - 1) * coord_add_j;
                const row_id: usize = @intCast(row_idx);
                const col_id: usize = @intCast(col_idx);
                compare1[k] = table[@as(usize, row_id)][@as(usize, col_id)];
            }
            std.log.info("Compare 2 is {s}", .{compare1});
            if (mem.eql(u8, pattern, &compare1)) {
                return 1;
            }
        }
        rotate(&coord_add_i, &coord_add_j);
        quarter_turn += 1;
    }
    return 0;
}

pub fn rotate(i: *i8, j: *i8) void {
    const buf_i = i.*;
    i.* = -1 * j.*;
    j.* = buf_i;
}

pub fn parseXmas(dir: Direction, table: [][]const u8, i: usize, j: usize) u32 {
    const pattern = "XMAS";

    var compare: [4]u8 = undefined;

    switch (dir) {
        .East => {
            for (0..4) |k| compare[k] = table[i][j + k];
        },
        .West => {
            for (0..4) |k| compare[k] = table[i][j - k];
        },
        .North => {
            for (0..4) |k| compare[k] = table[i - k][j];
        },
        .South => {
            for (0..4) |k| compare[k] = table[i + k][j];
        },
        .NorthEast => {
            for (0..4) |k| compare[k] = table[i - k][j + k];
        },
        .NorthWest => {
            for (0..4) |k| compare[k] = table[i - k][j - k];
        },
        .SouthEast => {
            for (0..4) |k| compare[k] = table[i + k][j + k];
        },
        .SouthWest => {
            for (0..4) |k| compare[k] = table[i + k][j - k];
        },
    }
    if (mem.eql(u8, pattern, &compare)) {
        return 1;
    } else {
        return 0;
    }
}
