/// heapify a slice of uints, bubbling up the max int
fn heapify(array: []u32) void {
    // for a binary tree representation of an array, the left child is
    // array[2 * parent + 1], and the right child is array[2 * parent + 2]
    //
    // identify the last-non leaf node
    var i: u32 = @divFloor(@as(u32, @intCast(array.len)) - 1 - 1, 2);
    while (true) : (i -= 1) {
        var j = i;
        while (true) {
            const parent = j;
            const left = 2 * j + 1;
            if (left >= array.len) break;
            const right = if (2 * j + 2 < array.len) 2 * j + 2 else left;
            var max: u32 = parent;
            max = if (array[max] > array[left]) max else left;
            max = if (array[max] > array[right]) max else right;
            if (max == parent) break;
            swap(&array[max], &array[parent]);
            j = max;
        }
        if (i == 0) break; // tree is balanced, need to break
    }
}

fn swap(left: *u32, right: *u32) void {
    const t = left.*;
    left.* = right.*;
    right.* = t;
}

const std = @import("std");

test {
    // first edge case: not a full tree, that is an odd len array
    var myarray: [5]u32 = .{ 4, 10, 100, 2, 200 };
    heapify(&myarray);
    try std.testing.expectEqualSlices(u32, &[5]u32{ 200, 10, 100, 2, 4 }, &myarray);
    // todo: create a test suite that tests a huge slice of random values
    // against the std library implementation
}
