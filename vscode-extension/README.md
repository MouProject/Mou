# Moulang for VS Code

Language support and native execution for Moulang, the programming language from the HAZOS development team.

Moulang is a work-in-progress programming language. HAZOS is actively developing it and publishes updates as test previews.

## News and updates

Read release notes and find compiler downloads on the [Moulang Releases page](https://github.com/Team-HaZos/Moulang/releases). Follow the [HAZOS project on GitHub](https://github.com/Team-HaZos/Moulang) for documentation and report issues through the [issue tracker](https://github.com/Team-HaZos/Moulang/issues).

The current extension source recognizes `.mcx` and the compatible suffixes `.m`, `.mxx`, `.mpp`, `.mcp`, `.m++`, and `.mc+`. Each uses the same highlighting, snippets, completion, and diagnostics. Use the matching Windows x64 compiler build for mixed-suffix imports.

Extension 0.2.2 completes `math.min`, `math.max`, `math.sum`, and list `.contains()`. The matching compiler 0.4.1 test preview supports `int("A")` for an ASCII code and `str(char(65))` for text output.

Extension 0.2.1 adds `Team.HaZos` to the MIT copyright notice. Version 0.2.0 introduced the new source associations, standard-module completions, and Tiki settings. Pair either extension version with compiler 0.4.0 for mixed-suffix imports and Tiki diagnostics. Compiler 0.2.0 uses `string` in explicit declarations.

## Install the compiler

Download the Windows x64 [compiler 0.4.2 test preview ZIP](https://github.com/Team-HaZos/Moulang/releases/download/v0.4.2/moulang-windows-x64.zip) and its [SHA-256 file](https://github.com/Team-HaZos/Moulang/releases/download/v0.4.2/moulang-windows-x64.zip.sha256), or [build the compiler from source](https://github.com/Team-HaZos/Moulang#build-from-source). Compare the ZIP's `Get-FileHash -Algorithm SHA256` result before extracting the whole package, for example to `C:\Moulang`. Keep `bin/toolchain` and its notices. The kit includes the tools needed to build and run Moulang programs.

Set `moulang.executablePath` to `C:\Moulang\bin\moulang.exe`, without quotes, or add the bin folder to PATH and restart VS Code. The extension does not install or download a compiler automatically. Run the extracted `Verify-Install.ps1` to check package hashes and execute Hello World.

1. Open the folder containing your Moulang source file.
2. Set **Moulang: Executable Path** to the full path to moulang.exe if it is outside PATH.
3. Open a saved Moulang source file and click the play button in the upper right of the editor, or run **Moulang: Run Current File** from the Command Palette. Output appears in the terminal and source diagnostics appear in **Problems**.

Enable **Moulang: Live Diagnostics** in a trusted workspace to check unsaved edits. This package uses the `KaichuTheFox.moulang` identity and `moulang.executablePath` setting. If you installed an earlier extension, set the compiler path again and disable the earlier extension to avoid duplicate file associations.

With a current Tiki-enabled compiler, set **Moulang: Tiki Mode** to `basic`, `perf`, `deep`, or `all` to show advisory warnings in **Problems**. The setting defaults to `off` and uses Live Diagnostics. Deep reports structural changes attempted through known aliases of lists in `foreach`. Use a compiler that supports `--tiki=deep` for that setting.

If the compiler cannot be found, choose **Open Settings** in the error notification and select `moulang.executablePath`. Use the path to the executable, without surrounding quotes. Keep the native compiler's complete bundled toolchain beside it.

## Compiler compatibility

- Extension 0.2.3 updates the repository and support links and pairs with the compiler 0.4.2 test preview.
- Extension 0.2.2 pairs with the compiler 0.4.1 test preview for integer-list math, list membership, and ASCII conversions.
- Extensions 0.2.0 and 0.2.1 pair with compiler 0.4.0 for all seven source suffixes, standard-module completion, and Tiki Inspector.
- Extension 0.1.6 pairs with compiler 0.3.0 for the new syntax and completion.
- Bundled extension 0.1.5 pairs with compiler 0.2.0 and updates download and setup guidance.
- Existing extension 0.1.4 can invoke compiler 0.2.0 by updating its executable path. It originally targeted compiler 0.1.1 and added compiler discovery and the settings action.
- Extension 0.1.3 requires compiler 0.1.1. It introduces the current extension identity and editor play button.
- Compiler and extension versions are separate. A VSIX alone does not install the native compiler.

Compiler 0.2.0 supports the documented string escapes, signed 64-bit long and ordinary function overloads. This extension highlights escapes; the compiler validates Unicode and decoded UTF-8. Earlier development archives may predate these features. See the [0.2.0 release notes](https://github.com/KaichuTheFox/Moulang/releases/tag/v0.2.0).

See the [compiler installation guide](https://github.com/Team-HaZos/Moulang#install-without-building) in the Moulang repository.

The extension is licensed under MIT.
