# Overview
This repository contains the code and results for the cp eval project.
The cp eval project aim is to better understand the use of LLMs in the modelling process for constraint programming, in particular using the [minizinc modelling language](https://www.minizinc.org/). In particular, we seek better understanding of the level of data contamination in the training data of LLMs. Tipically, most combinatorial optimization problems, are well known and studied by the community with a lot of free resources available on the web. This could lead to both problem descriptions and solution to be leaked into the LLMs training data. Without knowing the training data, it is particularly challenging to know if that is the case and performing task non present in the training data is crucial for a good evaluation of any machine learning model. Furthermore, classic problem descriptions are well written and defined in literature while, in general, a problem description could be messy, noisy and not as well defined. We aim at solving both of these problems with a set of rephrased problems from literature. The final problem descriptio will share the same underlying structure and objective but a different context and a more noisy problem description. By comparing the proposed solutions we aim at understanding how the LLM is able to perform the modelling task independently of its original context (to limit data contaminaition) and removing the noise.

# Repository structure
The repository is structured as follows:
- ```generate.py```: A python script to generate all models given an input LLM chosen between gpt4, claude4 and deepseek-r1.
- ```system_prompt.txt```: The system prompt used with all LLMs.
- ```problems```: The directory containing all problem descriptions and solutions.

Inside the ```problems``` folder, each problem has its own sub-directory structured as:
- ```specification.txt```: a txt file containing 2 problems description, the original from [csplib](https://www.csplib.org/) and the modified version written ex-novo. The file is formatted as:
    ```
    original:
    [... original description ...]
    modified:
    [... modified description ...]
    ```
    Each description can be multiple lines long.
- A series of sub-directory each named after a LLM containing:
    - ```api_modified.desc```: the answer produced by the LLM on the modified description (including model and reasining/explaination steps)
    - ```api_original.desc```: the answer produced by the LLM on the original description (including model and reasining/explaination steps)
    The folders are: GPT4 (for gpt4), R1 (for deepseek-r1) and Claude4 (for claude4)


# Install and reproduce
To reproduce our experiments just install the required libraries via ```pip install -r requirements.txt``` then remove all pre-made answers for each problem (api_modified.desc and api_original.desc) and run the ```generate.py``` script with one of the supported LLMs (gpt4, r1 and claude4), example:
```
python generate.py gpt4
```


# Overview

This repository contains the code and results for the **CP Eval Project**.
The aim of this project is to explore how large language models (LLMs) can support the modeling process in **constraint programming (CP)**, with a focus on the [MiniZinc modeling language](https://www.minizinc.org/).

In particular, we aim at addressing the **data contamination** problem in LLM training datasets. Many classic combinatorial optimization problems are well-documented online, which raises the risk that both problem statements and solutions may have been included in the LLM training data. Since training datasets are not publicly available, it is difficult to verify this directly. To evaluate model performance is crucial to present tasks not available in training data.

Furthermore, classic problem descriptions are well written and defined in literature while, in general, a problem description could be messy, noisy and not as well defined. We aim at addressing both of these problems with a set of **rephrased problems**. The rephrased problem description will share the same underlying structure and objective as a well-known combinatorial optimization problem but a different context and a noisier description.

By comparing LLM-generated solutions across original and rephrased problems, we aim to assess:

* How well LLMs perform modeling tasks independent of their exposure to standard formulations (reducing contamination effects).
* How robust LLMs are to noise and less structured problem descriptions.

---

# Repository Structure

The repository is organized as follows:

* **`generate.py`**: Python script to generate all models using a selected LLM (GPT-4, Claude-4, or DeepSeek-R1).
* **`system_prompt.txt`**: The system prompt provided to all LLMs.
* **`problems/`**: Directory containing problem descriptions and corresponding solutions.

Each problem in the `problems/` directory has its own subdirectory, structured as follows:

* **`specification.txt`** – Contains two versions of the problem statement:

  ```
  original:
  [... original description from [csplib](https://www.csplib.org/) ...]
  modified:
  [... rephrased version with altered context and added noise ...]
  ```

  Each description may span multiple lines.

* **Subdirectories for each LLM** (e.g., `GPT4/`, `Claude4/`, `R1/`), each containing:

  * **`api_original.desc`** – LLM’s response to the original problem description (including model and reasoning steps).
  * **`api_modified.desc`** – LLM’s response to the rephrased problem description (including model and reasoning steps).

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