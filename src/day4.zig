const std = @import("std");

const at = '@';

pub fn day4() !void {

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file = try std.fs.cwd().openFile("input/2025/day4_input.txt", .{});
    defer file.close();

    var buf: [1024]u8 = undefined;
    var fileReader = file.reader(&buf);
    const reader = &fileReader.interface;

    var table = try std.ArrayList([]u8).initCapacity(allocator, 0);
    defer table.deinit(allocator);

    while (try reader.takeDelimiter('\n')) |line| {
        const lineCopy = try allocator.dupe(u8, line);
        try table.append(allocator, lineCopy);
    }

    firstPart(table);
    secondPart(table);
}

fn secondPart(table: std.ArrayList([]u8)) void {
    var totalRolls: u32 = 0;
    var repeat = true;
    const lineTable = table.items.len;
    while (repeat) {
        var beenRemoved: u32 = 0;
        for (0..lineTable) |i| {
            for (0..table.items[0].len) |j| {
                if (table.items[i][j] == '.') {
                    continue;
                }
                var counter: u32 = 0;
                counter += numberUp(table.items, i, j);
                counter += numberDown(table.items, i, j);
                counter += numberLeft(table.items, i, j);
                counter += numberRight(table.items, i, j);
                if (counter < 4) {
                    totalRolls += 1;
                    table.items[i][j] = '.';
                    beenRemoved += 1;
                }
            }
        }
        if (beenRemoved == 0) repeat = false;
    }
    std.debug.print("SecondPart -- TotalRolls {}\n", .{ totalRolls });
}

fn firstPart(table: std.ArrayList([]u8)) void {
    var totalRolls: u32 = 0;
    const lineTable = table.items.len;
    for (0..lineTable) |i| {
        for (0..table.items[0].len) |j| {
            if (table.items[i][j] == '.') {
                continue;
            }
            var counter: u32 = 0;
            counter += numberUp(table.items, i, j);
            counter += numberDown(table.items, i, j);
            counter += numberLeft(table.items, i, j);
            counter += numberRight(table.items, i, j);
            if (counter < 4) {
                totalRolls += 1;
            }
        }
    }
    std.debug.print("FirstPart -- TotalRolls: {}\n", .{totalRolls});
}


fn numberUp(items: [][]u8, row: usize, col: usize) u32 {
    var res: u32 = 0;
    if (row == 0) {
        return res;
    }
    if (items[row - 1][col] == at) {
        res += 1;
    }
    if ((col != 0) and (items[row - 1][col - 1] == at)) {
        res += 1;
    }
    if ((col != items[0].len - 1) and (items[row - 1][col + 1] == at)) {
        res += 1;
    }
    return res;
}

fn numberDown(items: [][]u8, row: usize, col: usize) u32 {
    var res: u32 = 0;
    if (row == items.len - 1) {
        return res;
    }
    if (items[row + 1][col] == at) {
        res += 1;
    }
    if ((col != 0) and (items[row + 1][col - 1] == at)) {
        res += 1;
    }
    if ((col != items[0].len - 1) and (items[row + 1][col + 1] == at)) {
        res += 1;
    }
    return res;
}

fn numberLeft(items: [][]u8, row: usize, col: usize) u32 {
    var res: u32 = 0;
    if (col == 0) {
        return res;
    }
    else if (items[row][col - 1] == at) {
        res += 1;
    }
    return res;
}

fn numberRight(items: [][]u8, row: usize, col: usize) u32 {
    var res: u32 = 0;
    if (col == items[0].len - 1) {
        return res;
    }
    else if (items[row][col + 1] == at) {
        res += 1;
    }
    return res;
}
