// Tests transition between short and long encoding
contract c {
    bytes data;

    function test() public returns (uint256) {
        for (uint8 i = 1; i < 40; i++) {
            data.push(bytes1(i));
            if (data.length != i) return 0x1000 + i;
            if (data[data.length - 1] != bytes1(i)) return i;
        }
        for (uint8 i = 1; i < 40; i++)
            if (data[i - 1] != bytes1(i)) return 0x1000000 + i;
        return 0;
    }
}
// ====
// compileViaYul: also
// ----
// test() -> 0
// gas irOptimized: 397892
// gas legacy: 565428
// gas legacyOptimized: 552524
