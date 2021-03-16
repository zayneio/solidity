==== Source: A ====
pragma abicoder               v2;

struct Data {
    uint a;
    uint[2] b;
    uint c;
}

contract A {
    function get() public view returns (Data memory) {
        return Data(5, [uint(66), 77], 8);
    }
}

contract B {
    function foo(A _a) public returns (uint) {
        return _a.get().b[1];
    }
}
==== Source: B ====
import "A";

contract C is B {
    function test() public returns (uint) {
        return foo(new A());
    }
}
// ====
// compileViaYul: also
// ----
// test() -> 77
// gas irOptimized: 139834
// gas legacy: 159765
// gas legacyOptimized: 112983
