pragma abicoder v1;
contract C {
    function t(uint) public pure {}
}
// ====
// EVMVersion: >=byzantium
// compileViaYul: false
// revertStrings: debug
// ----
// t(uint256) -> FAILURE
