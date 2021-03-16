contract c {
    uint[20] spacer;
    uint[] dynamic;
    function fill() public {
        for (uint i = 0; i < 21; ++i)
            dynamic.push(i + 1);
    }
    function halfClear() public {
        while (dynamic.length > 5)
            dynamic.pop();
    }
    function fullClear() public { delete dynamic; }
}
// ====
// compileViaYul: also
// ----
// storage: empty
// fill() ->
// gas irOptimized: 536126
// gas legacy: 504368
// gas legacyOptimized: 499643
// storage: nonempty
// halfClear() ->
// storage: nonempty
// fullClear() ->
// storage: empty
