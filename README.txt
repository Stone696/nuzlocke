Run apply_final_cleanup.py from the repository root on nuzlocke-2.0-beta.

This corrective pass is based on the post-commit GitHub state at a93c997. It:
- applies the release identity changes that the accidentally committed repair helper never executed;
- updates current-document identity in README/main.lua/API/Compatibility/Feature Confidence/User Guide/Testing;
- adds the 29.3.0 changelog promotion entry if missing;
- deletes REPAIR_INSTRUCTIONS.md and apply_beta_29_3_0_repair.py from the working tree;
- does not alter gameplay logic.

After running, review git diff and run:
node tests/release_gate.js main.lua
