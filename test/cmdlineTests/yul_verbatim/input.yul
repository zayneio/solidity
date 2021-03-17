{
    let x := 2
    let y := sub(x, 2)
    let t := verbatim_2i_1o("abc", x, y)
    sstore(t, x)
    let r := verbatim_1o("def")
    verbatim("xyz")
    verbatim(hex"0102030405060709000102030405060709000102030405060709000102")
}
