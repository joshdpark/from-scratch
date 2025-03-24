/// heapify a slice of uints, bubbling up the max int
fn heapify(array: []u32) void {
    // for a binary tree representation of an array, the left child is
    // array[2 * parent + 1], and the right child is array[2 * parent + 2]
    //
    // identify the last-non leaf node
    var i: usize = @divFloor(array.len, 2);
    while (i > 0) {
        i -= 1;
        var parent = i;
        while (2 * parent + 1 < array.len) {
            var max: usize = parent;
            const left = 2 * parent + 1;
            for (left..@min(left + 2, array.len)) |child|
                max = if (array[max] > array[child]) max else child;
            if (max == parent) break;
            swap(&array[max], &array[parent]);
            parent = max;
        }
    }
}

fn swap(left: *u32, right: *u32) void {
    const t = left.*;
    left.* = right.*;
    right.* = t;
}

const std = @import("std");

// todo: create a test suite that tests a huge slice of random values
// against the std library implementation
// perhaps a good time to try and use a fuzzer?
test {
    var myarray: [5]u32 = .{ 4, 10, 100, 2, 200 };
    heapify(&myarray);
    try std.testing.expectEqualSlices(u32, &[5]u32{ 200, 10, 100, 2, 4 }, &myarray);
    // first edge case: not a full tree, that is an odd len array
    var b: [6]u32 = .{ 10, 5, 5, 1, 1, 6 };
    heapify(&b);
    try std.testing.expectEqualSlices(u32, &[6]u32{ 10, 5, 6, 1, 1, 5 }, &b);
}
