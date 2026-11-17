param(
    [Parameter(Mandatory = $true)] [string] $Compiler,
    [Parameter(Mandatory = $true)] [string] $TestRoot
)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/run-source.ps1"

$source = @'
str traced(str label) {
    print("trace", label)
    return label
}
main() {
    str name = ""
    str empty = "old"
    char byte = char(0)
    short small = short(0)
    int points = 0
    long big = 0
    float ratio = 0.0
    double value = 0.0
    bool ready = false
    print("{{ready}} {}", "ignored")
    print(traced("{{ready}} {} {}")) {
        format(traced("left"), traced("right"))
        input(name)
        input(empty)
        input(byte)
        input(small)
        input(points)
        input(big)
        input(ratio)
        input(value)
        input(ready)
    }
    print("{}{}:{} {} {} {} {} {} {}") {
        format(name, empty, byte, small, points, big, ratio, value, ready)
    }
    print("{{{}}}") { format("x\0y") }
    print("{{}}") { format() }
}
'@
$name = [char]::ConvertFromUtf32(0xD55C) + [char]::ConvertFromUtf32(0x1F600)
$inputBytes = $utf8.GetBytes("$name`r`n`n255`n-32768`n  +42 `n-9223372036854775808`n2.5`n-1.25e2`ntrue")
$r = Invoke-Moulang 'block.m' $source -InputBytes $inputBytes
$expected = '{{ready}} {} ignored' + "`n" + 'trace {{ready}} {} {}' +
    "`ntrace left`ntrace right`n{ready} left right`n" +
    "$($name):\xFF -32768 42 -9223372036854775808 2.5 -125 true`n{x$([char]0)y}`n{}`n"
if ($r.Code -ne 0 -or $r.Error -or $r.Out -cne $expected) {
    throw "Unexpected print block output: $($r.Code), [$($r.Out)], [$($r.Error)]."
}

$charOutput = @'
main() {
    print(char(65))
    print(char(66))
    print(char(67))
    print(char(97))
    print(int(char(65)))
    print(char(65), "\u{AC00}", 65, float(10), double(10), char(255))
    print("{} {} {} {}") { format(char(65), int(char(65)), float(10), double(10)) }
    print(str(char(0)) == "\0", str(char(10)) == "\n")
    for (byte=0 in byte++(256)) {
        char rendered = char(byte)
        print(rendered)
        print("[{}]") { format(rendered) }
    }
}
'@
$charLines = @('A', 'B', 'C', 'a', '65', "A $([char]0xAC00) 65 10 10 \xFF", 'A 65 10 10', 'true true')
$charLines += foreach ($byte in 0..255) {
    $rendered = if ($byte -ge 32 -and $byte -le 126) { [string][char]$byte } else { '\x{0:X2}' -f $byte }
    $rendered
    "[$rendered]"
}
$expectedChars = ($charLines + '') -join [char]10
$r = Invoke-Moulang 'char-output.mcx' $charOutput
if ($r.Code -ne 0 -or $r.Error -or $r.Out -cne $expectedChars) {
    throw "Unexpected char output: $($r.Code), [$($r.Out)], [$($r.Error)]."
}

foreach ($outside in -1, 256) {
    $r = Invoke-Moulang 'char-range.mcx' "main() { print(char($outside)) }"
    if ($r.Code -ne 1 -or $r.Out -or $r.Error -notmatch 'char-range[.]mcx:1:16:.*int value is outside the char range') {
        throw "Expected a source-located char range error for $outside. $($r.Error)"
    }
}

$compileErrors = @(
    @{ Source = 'main() { input(value) }'; Code = 'ML3042' },
    @{ Source = 'main() { format(0) }'; Code = 'ML3042' },
    @{ Source = 'main() { print(42) { format() } }'; Code = 'ML3042' },
    @{ Source = 'main() { print("prompt") { input(1) } }'; Code = 'ML2001' },
    @{ Source = 'main() { print("prompt") { input(missing) } }'; Code = 'ML3004' },
    @{ Source = "main() {`n    int n = 0`n    print(""{}"") {`n        input(n)`n        format(n)`n    }`n}"; Code = 'ML2008' }
)
foreach ($case in $compileErrors) {
    $r = Invoke-Moulang 'bad-block.m' $case.Source 'check'
    if ($r.Code -ne 1 -or $r.Error -notmatch $case.Code) { throw "Expected $($case.Code): $($r.Error)" }
}

foreach ($case in @(
    @{ Text = '{} {}'; Pattern = 'more placeholders' },
    @{ Text = 'no placeholder'; Pattern = 'fewer placeholders' },
    @{ Text = 'a { b }'; Pattern = 'invalid format brace' }
)) {
    $r = Invoke-Moulang 'bad-format.m' ('main() { print("' + $case.Text + '") { format(1) } }')
    if ($r.Code -ne 1 -or $r.Out -or $r.Error -notmatch $case.Pattern) {
        throw "Expected format error with no output: $($r.Code), [$($r.Out)], [$($r.Error)]."
    }
}

$read = "main() {`n    int n = 0`n    print(""prompt"") { input(n) }`n}"
foreach ($case in @(
    @{ Input = @(); Pattern = 'end of standard input' },
    @{ Input = $utf8.GetBytes("`n"); Pattern = 'invalid.*numeric input' },
    @{ Input = $utf8.GetBytes("10junk`n"); Pattern = 'invalid.*numeric input' },
    @{ Input = $utf8.GetBytes("2147483648`n"); Pattern = 'outside the variable' },
    @{ Input = @(255, 10); Pattern = 'not valid UTF-8' }
)) {
    $r = Invoke-Moulang 'bad-input.m' $read -InputBytes $case.Input
    if ($r.Code -ne 1 -or $r.Out -cne "prompt`n" -or $r.Error -notmatch $case.Pattern) {
        throw "Expected input error after prompt: $($r.Code), [$($r.Out)], [$($r.Error)]."
    }
}
