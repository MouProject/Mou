# Moulang 0.4.2 test preview

The Windows x64 bundle contains compiler 0.4.2, its matching runtime and link kit, and Moulang for VS Code 0.2.2.

## Character output

Both `print()` and block `format()` display ASCII bytes 32 through 126 as characters. All other `char` values display as `\xHH` with two uppercase hexadecimal digits. Use `int(character)` to keep decimal byte codes in existing logs, tests, or parsers. The `char` type is still an unsigned 8-bit value. `str(char)` still produces the original ASCII byte in a string, and floating-point rendering follows the existing rules.

```moulang
main() {
    print(char(65), int(char(65)), char(10))
    print("Letter: {}") { format(char(66)) }
    print(float(10))
}
```

```text
A 65 \x0A
Letter: B
10
```

## Install and test

Compare the ZIP checksum with the supplied SHA-256 file, extract the bundle to a new folder, and run its `Verify-Install.ps1`. Confirm that `bin/moulang.exe --version` reports `Moulang 0.4.2`. In VS Code, point `moulang.executablePath` to the extracted compiler. An existing installation of extension 0.2.2 works with this preview. See the [installation guide](INSTALL.md).
