/// heapify a slice of uints, bubbling up the max int
/// starting from the last inner node (non-leaf node)
///     1. descend into the larger branch
///     2. if leaf break, else goto 1
///     3. if current node is > starting node
///         4. go to the parent of current node,
///         5. swap parent node with starting node
///         6. current <- parent
///         7. goto 4 until current = starting
fn heapify(array: []u32) void {
    // for a binary tree representation of an array, the left child is
    // array[2 * parent + 1], and the right child is array[2 * parent + 2]
    //
    // identify the last-non leaf node
    var head = array.len / 2;
    var cur: usize = undefined;
    var child: usize = undefined;
    while (head > 0) {
        head -= 1;
        cur = head;
        // descend to leaf, choosing the max each time
        while (true) {
            child = cur * 2 + 1;
            if (child + 1 >= array.len) break;
            cur = if (array[child] > array[child + 1]) child else child + 1;
        }
        if (child + 1 == array.len)
            cur = child;
        // ascend to where cursor > head
        while (true) : (cur = (cur - 1) / 2) {
            if (cur == head or array[cur] > array[head]) break;
        }
        while (cur != head) {
            swap(&array[cur], &array[head]);
            cur = (cur - 1) / 2;
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

    // using output from python random.randint and heapq.heapfiy
    var c: [100]u32 = .{ 48, 54, 60, 28, 8, 63, 20, 83, 8, 40, 82, 61, 61, 12, 70, 58, 62, 39, 21, 68, 7, 62, 7, 54, 84, 42, 31, 93, 55, 25, 3, 61, 31, 14, 88, 26, 54, 54, 17, 45, 38, 81, 97, 64, 5, 32, 72, 83, 93, 60, 16, 21, 85, 97, 24, 33, 53, 2, 62, 87, 59, 5, 80, 64, 93, 90, 92, 95, 12, 98, 59, 92, 81, 21, 82, 59, 5, 55, 15, 12, 38, 23, 58, 44, 23, 98, 6, 9, 26, 58, 13, 3, 80, 90, 30, 60, 36, 81, 67, 77 };
    heapify(&c);
    try std.testing.expectEqualSlices(u32, &[100]u32{ 98, 98, 97, 95, 97, 93, 93, 93, 92, 81, 90, 84, 85, 62, 87, 92, 88, 82, 59, 68, 54, 64, 82, 83, 77, 63, 61, 53, 55, 70, 80, 64, 90, 83, 62, 81, 54, 54, 55, 45, 58, 44, 40, 62, 58, 80, 72, 61, 81, 60, 16, 21, 42, 31, 24, 33, 12, 2, 20, 25, 59, 5, 3, 58, 61, 48, 31, 14, 12, 28, 59, 26, 39, 21, 8, 21, 5, 17, 15, 12, 38, 23, 38, 8, 23, 7, 6, 9, 26, 5, 13, 3, 32, 7, 30, 60, 36, 54, 67, 60 }, &c);
}
