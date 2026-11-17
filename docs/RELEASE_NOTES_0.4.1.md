# Moulang 0.4.1 test preview

This Windows x64 test preview bundles compiler 0.4.1, its matching runtime and native link kit, and Moulang for VS Code 0.2.2. Use it to test the new library functions and report compatibility issues. The extension ID remains `KaichuTheFox.moulang`.

## Changes

- Use `math.min`, `math.max`, and `math.sum` with `int[]`, including direct list literals. A sum returns a `long` and an empty sum is zero. Minimum and maximum require a nonempty list.
- Check membership with `.contains()` on `int[]` and flat `str[]`. The VS Code extension completes the new list method and `math.sum`.
- Read an ASCII code with `int("A")` and produce ASCII text with `str(char(65))`. Direct output of a `char` still renders its numeric byte value.
- Run the [standard library and seeded lottery example](../examples/standard-library-update.mcx) from the source checkout.

## Install and test

Compare the ZIP checksum with the supplied SHA-256 file. Extract the entire bundle to a separate folder and run its `Verify-Install.ps1`. Confirm that `bin/moulang.exe --version` reports `Moulang 0.4.1`. Install the included `moulang-0.2.2.vsix` and set `moulang.executablePath` to the extracted compiler if it is outside PATH. Keep the runtime archive and native link kit beside the compiler. See the [installation guide](INSTALL.md).
