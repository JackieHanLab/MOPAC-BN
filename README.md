# Proteomic Aging Analysis: BN & SEM

Workflow for inferring and validating directed relationships in organ-proxy aging clocks using Bayesian Networks and Structural Equation Modeling.

---

## 📊 Project Overview

This project provides a robust statistical pipeline to study how different organs interact during the aging process. By combining **Bayesian Network (BN)** structure learning with **Structural Equation Modeling (SEM)**, we move beyond simple correlations to explore potential directed architectures.

### Analysis Pipeline
1.  **Structure Discovery**: Uses the `bnlearn` package to identify organ-to-organ connections.
2.  **Statistical Validation**: Translates the learned network into an SEM framework via `lavaan` to obtain standardized coefficients and global fit indices.

---

## 🛠 Prerequisites

Ensure you have **R (version 4.0 or higher)** installed. You will need the following libraries:

```R
# Install required packages from CRAN
install.packages("bnlearn")
install.packages("lavaan")
```

---

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute this code with attribution.
