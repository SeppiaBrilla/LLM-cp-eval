# Overview

This repository contains the code and results for the **CP Eval Project**.
The aim of this project is to explore how large language models (LLMs) can support the modeling process in **constraint programming (CP)**, with a focus on the [MiniZinc modeling language](https://www.minizinc.org/).

In particular, we aim at addressing the **data contamination** problem in LLM training datasets. Many classic combinatorial optimization problems are well-documented online, which raises the risk that both problem statements and solutions may have been included in the LLM training data. Since training datasets are not publicly available, it is difficult to verify this directly. To evaluate model performance is crucial to present tasks not available in training data.

Furthermore, classic problem descriptions are well written and defined in literature while, in general, a problem description could be messy, noisy and not as well defined. We aim at addressing both of these problems with a set of **rephrased problems**. The rephrased problem description will share the same underlying structure and objective as a well-known combinatorial optimization problem but a different context and a noisier description.

By comparing LLM-generated solutions across original and rephrased problems, we aim to assess:

* How well LLMs perform modeling tasks independent of their exposure to standard formulations (reducing contamination effects).
* How robust LLMs are to noise and less structured problem descriptions.

Finally, to asses the level of data contamination we asked each LLM to complete each problem description. We then compare the completed problem description with the corresponding original to determine how close they are.

---

# Repository Structure

The repository is organized as follows:

* **`generate.py`**: Python script to generate all models using a selected LLM (GPT-4, Claude-4, or DeepSeek-R1).
* **`complete.py`**: Python script to complete the problems descriptions using a selected LLM (GPT-4, Claude-4, or DeepSeek-R1).
* **`system_prompt.txt`**: The system prompt provided to all LLMs.
* **`problems/`**: Directory containing problem descriptions and corresponding solutions.

Each problem in the `problems/` directory has its own subdirectory, structured as follows:

* **`specification.txt`** – Contains two versions of the problem statement:

  ```
  original:
  [... original description from [csplib](https://www.csplib.org/) ...]
  modified-context-only:
  [... rephrased version with altered context ...]
  modified-distractor:
  [... rephrased version with altered context and added noise ...]
  ```

  Each description may span multiple lines.

* **Subdirectories for each LLM** (e.g., `GPT4/`, `Claude4/`, `R1/`), each containing:

  * **`api_original.desc`** – LLM’s response to the original problem description (including model and reasoning steps).
  * **`api_modified-context.desc`** – LLM’s response to the rephrased problem description (including model and reasoning steps).
  * **`api_modified-distracto.desc`** – LLM’s response to the rephrased and with added noise problem description (including model and reasoning steps).
  * **`problem_completion.txt`** – Original problem description completed by the LLM.
  * **`summary.json`** – Summary of results of the two models. It contains a **`similar`** key that it is true if the generated problem completion is similar to the original from CSPlib, false otherwise. Then, under the **`original`**, **`modified-context`** and **`modified-distractor`** keys, there are 3 boolean sub-keys: 
    * **`runs`**: if the models runs and it solves the problem correctly, e.g. the constraints actually do what they are supposed to do.
    * **`globals`**: if the model contains global constraints.
    * **`correctProblem`**: if the proposed model solves the correct problem.

---

# Installation & Reproduction

To reproduce our experiments:

1. Install the required dependencies:

   ```bash
   pip install -r requirements.txt
   ```
2. Remove any pre-generated answers (`api_original.desc` and `api_modified.desc`) from each problem directory.
3. Run the generation script with one of the supported LLMs (`gpt4`, `claude4`, `r1`). Example:

   ```bash
   python generate.py gpt4
   ```
4. Run the completition script with one of the supported LLMs (`gpt4`, `claude4`, `r1`). Example:

   ```bash
   python complete.py gpt4
   ```
