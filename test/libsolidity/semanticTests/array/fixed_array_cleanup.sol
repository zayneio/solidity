contract c {
    uint spacer1;
    uint spacer2;
    uint[20] data;
    function fill() public {
        for (uint i = 0; i < data.length; ++i) data[i] = i+1;
    }
    function clear() public { delete data; }
}
// ====
// compileToEwasm: also
// compileViaYul: also
// ----
// storage: empty
// fill() ->
// gas irOptimized: 423880
// gas legacy: 429455
// gas legacyOptimized: 425515
// storage: nonempty
// clear() ->
// storage: empty
