contract C {
    event E();
    function f() public pure {
        revert E();
    }
}
// ----
// TypeError 3132: (74-77): Event invocations have to be prefixed by "emit".
