pragma experimental SMTChecker;
contract C {
	int[][] array2d;
	function s() public returns (int[] memory) {
		delete array2d.push();
		assert(array2d[array2d.length - 1].length == 0);
		// Fails
		assert(array2d[array2d.length - 1].length != 0);
		delete array2d.push().push();
		uint length = array2d.length;
		uint length2 = array2d[length - 1].length;
		assert(array2d[length - 1][length2 - 1] == 0);
		// Fails
		assert(array2d[length - 1][length2 - 1] != 0);
		return array2d[2];
	}
}
// ----
// Warning 6328: (198-245): CHC: Assertion violation happens here.\nCounterexample:\narray2d = [[]]\n = []\nlength = 0\nlength2 = 0\n\nTransaction trace:\nC.constructor()\nState: array2d = []\nC.s()
// Warning 6328: (418-463): CHC: Assertion violation happens here.\nCounterexample:\narray2d = [[], [0]]\n = []\nlength = 2\nlength2 = 1\n\nTransaction trace:\nC.constructor()\nState: array2d = []\nC.s()
